package com.stamen.logic.tests
{
	import asunit.textui.TestRunner;
	
	public class Runner extends TestRunner
	{
		public function Runner()
		{
			start(LogicTestCase);//, null, TestRunner.SUCCESS_EXIT);
		}
	}
}
