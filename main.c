#include <stdio.h>
#include "stm32f4xx.h"
#include "stm32f4xx_gpio.h"
#include "FreeRTOS.h"
#include "task.h"

static void setup_hardware(void);
void simple_task(void* pvParameters);
void init_LED(void);

int main(void) 
{
	setup_hardware();
	init_LED();	
	xTaskCreate(simple_task, "Simple Task", 128, NULL, 2, NULL);
  	vTaskStartScheduler();
  	for (;;);
}

void vApplicationIdleHook(void) 
{
	//Idle Task	
}

void vApplicationStackOverflowHook(TaskHandle_t xTask, char* pcTaskName) 
{
  	for (;;);
}

void vApplicationMallocFailedHook(void) 
{
  	for (;;);
}

static void setup_hardware(void) 
{
	SystemInit();
	NVIC_PriorityGroupConfig(NVIC_PriorityGroup_4);
}


void vApplicationGetIdleTaskMemory(StaticTask_t** ppxIdleTaskTCBBuffer, StackType_t** ppxIdleTaskStackBuffer, uint32_t* pulIdleTaskStackSize) 
{
	static StaticTask_t xIdleTaskTCB;
	static StackType_t uxIdleTaskStack[configMINIMAL_STACK_SIZE];
  
	*ppxIdleTaskTCBBuffer = &xIdleTaskTCB;
	*ppxIdleTaskStackBuffer = uxIdleTaskStack;
	*pulIdleTaskStackSize = configMINIMAL_STACK_SIZE;
}
static StaticTask_t xTimerTaskTCB;
static StackType_t uxTimerTaskStack[configTIMER_TASK_STACK_DEPTH];


void vApplicationGetTimerTaskMemory(StaticTask_t** ppxTimerTaskTCBBuffer, StackType_t** ppxTimerTaskStackBuffer, uint32_t* pulTimerTaskStackSize) 
{
	*ppxTimerTaskTCBBuffer = &xTimerTaskTCB;
	*ppxTimerTaskStackBuffer = uxTimerTaskStack;
	*pulTimerTaskStackSize = configTIMER_TASK_STACK_DEPTH;
}

void simple_task(void* pvParameters) 
{
	
	for (;;) 
	{
		GPIO_ToggleBits(GPIOD, GPIO_Pin_14 | GPIO_Pin_12);
		vTaskDelay(500);
  	}

	vTaskDelete(NULL);
}

void init_LED(void)
{
  	GPIO_InitTypeDef GPIO_InitStruct;
  	RCC_AHB1PeriphClockCmd(RCC_AHB1Periph_GPIOD, ENABLE);
  	GPIO_InitStruct.GPIO_Pin = GPIO_Pin_12 | GPIO_Pin_14;
	GPIO_InitStruct.GPIO_Mode = GPIO_Mode_OUT;
	GPIO_InitStruct.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_InitStruct.GPIO_OType = GPIO_OType_PP;
	GPIO_InitStruct.GPIO_PuPd = GPIO_PuPd_NOPULL;
	GPIO_Init(GPIOD, &GPIO_InitStruct);
}

