#include "VCore.h"

#include <verilated.h>
#include <verilated_fst_c.h>

#include <bit>

#include <memory>
#include <vector>
#include <iostream>
#include <fstream>

#include <cstdint>
#include <cassert>

#include <sys/select.h>
#include <sys/time.h>

const double TIMESCALE       = 1e-9;
const int    CLOCK_FREQUENCY = 100*1e6;
const int    CLOCK_PERIOD    = 1/(CLOCK_FREQUENCY*TIMESCALE);

const std::uint64_t MAX_CYCLES = 1000000000ULL;

const unsigned int MEMBUS_WORDS = 4;
const unsigned int MEMBUS_OFFSET = 2 + std::bit_width(MEMBUS_WORDS) - 1;

#ifdef LOG_STORES_ENABLED
const bool log_stores = true;
#else
const bool log_stores = false;
#endif

#ifdef TRACE_DUMP_ENABLED
const bool trace_dump = true;
#else
const bool trace_dump = false;
#endif

class Memory
{
public:

    Memory(VCore& top, const char* memoryFile) : top_{top}
    {
        auto ifs = std::ifstream{memoryFile, std::ifstream::binary};
        auto memoryBytes =
            std::vector<unsigned char>{std::istreambuf_iterator<char>(ifs), {}};

        assert((memoryBytes.size() % 4 == 0) &&
               "Memory does not contain a multiple of words");

        auto i = std::size_t{0};

        while (i < memoryBytes.size())
        {
            auto b0 = memoryBytes[i++];
            auto b1 = memoryBytes[i++];
            auto b2 = memoryBytes[i++];
            auto b3 = memoryBytes[i++];

            auto word = b0 | (b1 << 8) | (b2 << 16) | (b3 << 24);
            memory_.push_back(word);
        }
    }

    void eval(vluint64_t cycle)
    {
        top_.io_axi_arw_ready = true;
        top_.io_axi_w_ready = true;
        top_.io_axi_r_valid = false;
        top_.io_axi_b_valid = false;

        if (nextReadCycle_ == cycle)
        {
            for (unsigned i = 0; i < MEMBUS_WORDS; ++i) {
                top_.io_axi_r_payload_data[i] = nextReadData_[i];
            }
            top_.io_axi_r_payload_id = nextReadId_;
            top_.io_axi_r_payload_last = true;
            top_.io_axi_r_valid = true;
            nextReadCycle_ = 0;

            assert(top_.io_axi_r_ready);
        }

        if (top_.io_axi_arw_valid)
        {
            if (top_.io_axi_arw_payload_write)
            {
                write(top_.io_axi_arw_payload_addr,
                      top_.io_axi_w_payload_strb,
                      top_.io_axi_w_payload_data);

                top_.io_axi_b_valid = true;
            }
            else
            {
                read(top_.io_axi_arw_payload_addr, nextReadData_);
                nextReadCycle_ = cycle + 1;
                nextReadId_ = top_.io_axi_arw_payload_id;
            }
        }
    }

private:

    using Address = std::uint32_t;
    using Word = std::uint32_t;
    using Mask = std::uint32_t;

    void read(Address address, WDataOutP value)
    {
        ensureEnoughMemory(address);

        auto baseAddress = (address >> MEMBUS_OFFSET) << (MEMBUS_OFFSET - 2);

        for (unsigned i = 0; i < MEMBUS_WORDS; ++i) {
            value[i] = memory_[baseAddress + i];
        }
    }

    void write(Address address, Mask mask, WDataInP value)
    {
        ensureEnoughMemory(address);

        auto bitMask = Word{0};
        auto baseAddress = (address >> MEMBUS_OFFSET) << (MEMBUS_OFFSET - 2);

        for (unsigned i = 0; i < MEMBUS_WORDS; ++i) {
            bitMask = 0;

            for (int byte = 0; byte < 4; ++byte) {
                if (mask & (1 << (4 * i + byte))) {
                    bitMask |= 0xff << (8 * byte);
                }
            }

            if (bitMask != 0) {
                auto& memoryValue = memory_[baseAddress + i];
                memoryValue &= ~bitMask;
                memoryValue |= value[i] & bitMask;
                if (log_stores) {
                    std::cerr << std::hex << "Store at " << baseAddress << " with value " << value[i] << std::endl;
                }
            }
        }
    }

    void ensureEnoughMemory(Address address)
    {
        auto baseAddress = ((address >> MEMBUS_OFFSET) + 1) << (MEMBUS_OFFSET - 2);

        if ((baseAddress) >= memory_.size())
        {
            memory_.reserve(baseAddress + 1);

            while ((baseAddress) >= memory_.size())
                memory_.push_back(0xcafebabe);
        }
    }

    VCore& top_;
    std::vector<Word> memory_;
    uint32_t nextReadData_[MEMBUS_WORDS];
    vluint64_t nextReadCycle_ = 0;
    vluint8_t nextReadId_;
};

class CharDev
{
public:

    CharDev(VCore& top) : top_{top}, gotEot_{false}
    {
    }

    void eval()
    {
        if (top_.io_charOut_valid)
        {
            auto charOut = char(top_.io_charOut_payload);

            if (charOut == 0x4)
                gotEot_ = true;
            else
            {
                gotEot_ = false;
                std::cout << charOut;
            }
        }
    }

    bool gotEot() const
    {
        return gotEot_;
    }

private:

    VCore& top_;
    bool gotEot_;
};

class TestDev
{
public:

    TestDev(VCore& top) : top_{top}, result_{-1}
    {
    }

    void eval()
    {
        if (top_.io_testDev_valid)
            result_ = top_.io_testDev_payload;
    }

    bool gotResult() const
    {
        return result_ >= 0;
    }

    bool hasFailed() const
    {
        return gotResult() && result_ != 0;
    }

    int failedTest() const
    {
        assert(hasFailed() && "No failed tests");
        return result_;
    }

private:

    VCore& top_;
    int result_;
};

class ByteDev
{
public:

    ByteDev(VCore& top) : top_{top}
    {
    }

    bool eval()
    {
        if (top_.reset)
            return false;

        top_.io_byteDev_rdata_valid = false;

        if (top_.io_byteDev_wdata_valid)
        {
            auto charOut = char(top_.io_byteDev_wdata_payload);
            std::cout << charOut;
        }

        if (!hasStdinByte && stdinAvailable())
        {
            currentStdinByte = std::cin.get();
            hasStdinByte = !std::cin.eof();
        }

        if (hasStdinByte)
        {
            top_.io_byteDev_rdata_valid = true;
            top_.io_byteDev_rdata_payload = currentStdinByte;

            if (top_.io_byteDev_rdata_ready)
                hasStdinByte = false;

            return true;
        }

        return false;
    }

private:

    bool stdinAvailable() const
    {
        if (std::cin.eof())
            return false;

        fd_set rfds;
        FD_ZERO(&rfds);
        FD_SET(STDIN_FILENO, &rfds);

        timeval tv;
        tv.tv_sec = 0;
        tv.tv_usec = 0;

        int result = select(1, &rfds, nullptr, nullptr, &tv);
        return result == 1;
    }

    VCore& top_;
    char currentStdinByte;
    bool hasStdinByte = false;
};

int main(int argc, char** argv)
{
    assert(argc >= 2 && "No memory file name given");

    Verilated::commandArgs(argc, argv);

    auto top = std::unique_ptr<VCore>{new VCore};
    top->reset = 1;
    top->clk = 1;

    auto memoryFile = argv[argc - 1];
    auto memory = Memory{*top, memoryFile};
    auto charDev = CharDev{*top};
    auto testDev = TestDev{*top};
    auto byteDev = ByteDev{*top};

    Verilated::traceEverOn(true);
    auto tracer = std::unique_ptr<VerilatedFstC>{new VerilatedFstC};
    top->trace(tracer.get(), 99);
    tracer->open("sim.fst");

    vluint64_t mainTime = 0;
    vluint64_t cycle = 0;
    auto isDone = false;
    int result = 0;

    while (!isDone)
    {
        auto clockEdge = (mainTime % (CLOCK_PERIOD/2) == 0);

        if (clockEdge)
            top->clk = !top->clk;

        if (mainTime >= 5*CLOCK_PERIOD)
            top->reset = 0;

        top->eval();

        if (clockEdge && top->clk)
        {
            cycle++;

            memory.eval(cycle);
            top->eval();
            //memory.eval(cycle);
            //top->eval();

            charDev.eval();
            testDev.eval();

            if (charDev.gotEot())
                isDone = true;

            if (testDev.gotResult())
            {
                isDone = true;

                if (testDev.hasFailed())
                {
                    std::cerr << "Test " << testDev.failedTest() << " failed\n";
                    result = 1;
                }
                else
                    std::cout << "All tests passed\n";
            }

            if (byteDev.eval())
                top->eval();

            if (mainTime >= MAX_CYCLES*CLOCK_PERIOD)
            {
                isDone = true;
                result = 1;
            }
        }

        if (trace_dump) {
            tracer->dump(mainTime);
        }

        mainTime++;
    }

    tracer->close();
    return result;
}
