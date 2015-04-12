/*
 Turbo driver 
*/


#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/cpumask.h>
#include <linux/cpu.h>

static unsigned int turbo_active = 1;
module_param(turbo_active, uint, 0664);

#ifdef CONFIG_CPU_OVERCLOCK
static unsigned int mc_oc_disabled = 0;
module_param(mc_oc_disabled, uint, 0664);
#endif

#define FST_FREQ_BEFORE		122880
#define FST_FREQ_AFTER		245760
#define SND_FREQ_BEFORE		320000
#define SND_FREQ_AFTER		700800
#define TRD_FREQ_BEFORE		480000
#define MAX_CPU_FREQ		1008000

#ifdef CONFIG_INTELLI_PLUG
int msm_turbo_active(int tactive)
{
	tactive = turbo_active;
	return tactive;
}
#endif

int msm_turbo(int cpufreq)
{
	if (turbo_active) {
		if (num_online_cpus() == 2) {
			if (cpufreq == FST_FREQ_BEFORE) {
				cpufreq = FST_FREQ_AFTER;
				cpu_down(1);
			} else if (cpufreq == SND_FREQ_BEFORE) {
				cpufreq = SND_FREQ_AFTER;
				cpu_down(1);
			} else if (cpufreq == TRD_FREQ_BEFORE) {
				cpufreq = MAX_CPU_FREQ;
				cpu_down(1);
#ifndef CONFIG_CPU_OVERCLOCK
			}
#else
			} else if (cpufreq > MAX_CPU_FREQ)
				 if (mc_oc_disabled)
					cpufreq = MAX_CPU_FREQ;
#endif
		}
	}
	return cpufreq;
}

static int msm_turbo_boost_init(void)
{
	return 0;
}

static void msm_turbo_boost_exit(void)
{

}

module_init(msm_turbo_boost_init);
module_exit(msm_turbo_boost_exit);

