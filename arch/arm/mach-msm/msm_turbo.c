/*
 Turbo driver 
*/


#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/cpumask.h>
#include <linux/cpu.h>

extern int turbo_start_dec(int);

int msm_turbo(int cpufreq, int param)
{
	param = turbo_start_dec(param);
	if (param) {
		if (num_online_cpus() == 2) {
			if (cpufreq == 122880) {
				cpufreq = 245760;
				cpu_down(1);
			} else if (cpufreq == 320000) {
				cpufreq = 700800;
				cpu_down(1);
			} else if (cpufreq == 480000) {
				cpufreq = 1008000;
				cpu_down(1);
			}
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

