# ALU_UPF
# Project: Power Management using Unified Power Format (UPF) 

**Team Members:**
- Paolo Borgis 
- Massimo Giacobbe 
- Giuseppe Salvatore Piazza
- ## Folder organization
-  vhdl: contains all the vhdl source file
-  tb_upf: contains compilation scripts, upf file and testbench
-  results: contains all the power reports of the various modes analyzed(summarized in [Results and Achievements](#results-and-achievements))

- ## Table of Contents

1. [Project Overview](#project-overview)
2. [Objectives](#objectives)
3. [Power Domain Architecture](#power-domain-architecture)
4. [Dynamic Voltage and Frequency Scaling (DVFS)](#dynamic-voltage-and-frequency-scaling-dvfs)
5. [UPF Integration](#upf-integration)
6. [Power Analysis and Optimization](#power-analysis-and-optimization)
7. [Results and Achievements](#results-and-achievements)

---

## Project Overview

This project explores the use of **Unified Power Format (UPF)** to manage power consumption in complex electronic systems. The goal is to implement a robust power management strategy by controlling power domains, scaling voltages dynamically, and applying power gating. The project integrates UPF with VHDL-based design, leveraging tools like Synopsys for synthesis, simulation, and power analysis.

---

## Objectives

The primary objective is to reduce overall power consumption by:
- Implementing multiple power domains in the system to manage different components efficiently.
- Employing **Dynamic Voltage and Frequency Scaling (DVFS)** to adjust power supply based on workload.
- Using UPF to describe and control power intent across the design, ensuring minimal energy usage while maintaining system performance.

---

## Power Domain Architecture

The system was divided into several **power domains**, each handling a specific function and independently managed to optimize energy usage.

### Power Domains:
- **Core Domain**: Handles the primary logic operations.
- **Peripheral Domain**: Manages I/O functionalities.
- **Memory Domain**: Controls the storage subsystem.

By isolating these components into different power domains, we could selectively power down sections of the system that were not in use, reducing both dynamic and static power consumption.

---

## Dynamic Voltage and Frequency Scaling (DVFS)

DVFS is a critical technique in this project, enabling adaptive scaling of the supply voltage and clock frequency based on real-time performance requirements. The system dynamically adjusts:
- **Voltage**: Lowered during idle periods to reduce power.
- **Frequency**: Reduced alongside voltage to further limit energy consumption without affecting operational efficiency.

The implementation allowed the system to operate at lower power when less performance was required and rapidly increase power only when necessary.

---

## UPF Integration

UPF was used to define the power intent and control mechanisms across the different power domains. It specified how the system manages power under varying conditions.

### Key UPF Features Implemented:
- **Power Switches**: Enabled power gating to turn off inactive domains.
- **Isolation Cells**: Prevented leakage or data corruption when transitioning between powered and unpowered states.
- **Retention Cells**: Ensured that data was retained in memory when a power domain was switched off.
- **Level Shifters**: Maintained signal integrity between domains running at different voltage levels.

### Commands and UPF Flow:
- `create_power_domain`: Created and defined the boundaries of each power domain.
- `set_isolation` and `set_retention`: Defined the isolation and retention strategies for the design, crucial for preventing signal integrity issues.
- `add_power_switch`: Added power switches to allow specific domains to be gated during low-power operation.

This power management infrastructure allowed for flexible control of the system’s power usage and ensured a smooth transition between power states.

---

## Power Analysis and Optimization

After integrating UPF, Synopsys tools were used to:
1. **Synthesize the design** with the power management features in place.
2. **Analyze power consumption** across the various domains, identifying where optimizations could be made.
3. **Perform hierarchical power analysis**, breaking down power usage by domain and function.

### Key Techniques:
- **Power Gating**: Achieved significant power savings by shutting down unused domains.
- **Voltage Scaling**: Reduced power consumption during low workload periods.
- **Hierarchical Analysis**: Provided insights into the power consumed by individual components within each domain.

This analysis helped us fine-tune the system for maximum power savings while ensuring performance benchmarks were met.

---

## Results and Achievements

### Power Savings
The project achieved a **25% reduction in total power consumption** by:
- Dynamically controlling supply voltage and frequency in response to system demands.
- Implementing power gating for inactive domains.

### Performance Impact
Despite the power optimizations, the system maintained robust performance across all tasks. The use of isolation and retention strategies ensured no data loss during power transitions.

### Challenges Overcome
- **Signal Integrity**: Level shifters and isolation cells effectively handled cross-domain communication between different voltage levels.
- **Timing and Retention**: Carefully timed power-down sequences ensured that critical data was never lost during low-power states.

---

## Tools and Technologies
- **Synopsys Design Compiler** for UPF integration, synthesis, and power analysis.
- **VHDL** for the hardware design of the system.
- **Modelsim** for simulation of the design and verification of functionality.

---

## Conclusion

This project successfully demonstrated the power-saving potential of the Unified Power Format (UPF) by implementing a multi-domain, dynamically scalable system. By integrating UPF with DVFS and power gating techniques, we were able to create a highly efficient design that conserves energy while maintaining performance, setting the stage for further enhancements in power management strategies for digital systems.
