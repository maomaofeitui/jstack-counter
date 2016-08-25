# jstack-counter
This script counts interesting threads in stacktraces dumped by java jstack

# Analyzing performance issues using stack traces
Have you ever had performance problems with your java service? Does your service response is too long? CPU usage increased near to 100%?
How to debug such issues on production servers?
One of possible approach is to dump stack traces of all threads and analyze what service is doing.
There are a lot of tools to dump stack traces: java mission control, visual vm, jconsole.

But I often use simple [jstack](http://docs.oracle.com/javase/7/docs/technotes/tools/share/jstack.html) from JDK.
Mainly because it allow to dump threads directly from command line of running server.

# Interesting threads
Analyzing full stack traces is boring and arduous process. Especially when service has hundreds of threads. It's often desirable to *have fast insight* into interesting threads. What the most interesting threads are? Threads which are running my code (code developed by my team), doing database operations etc.

jstack-counter.awk is an awk script, which parses stacktraces dumped by jstack, looks for interesting threads and count them. As a result you will see a list of interesting threads named by running method.

#Example
Let's say that interesting threads are those running methods from following packages:

* pl.zxspeccy
* oracle.jdbc
* com.mchange.v2

Stacktraces are dumped to file stack-traces.jtdp. Running script by `awk -f jstack-counter.awk stack-traces.jtdp` you can see following output:

```
Interesting threads counts:
pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doGetItemsList 2
pl.zxspeccy.geronimo.json.client.JsonClient.invokeJSONMethod 2
oracle.jdbc.driver.T2CConnection.t2cCommit 6
pl.zxspeccy.mobius.recommendations.commands.GetRecommendationsCommand.run 1
pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doGetMyWonItems 1
pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doGetMyWatchItems 9
pl.zxspeccy.mobius.vacations.hystrix.GetUserVacationsCommand.getAndParseUserVacations 1
pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doShowItemInfoExt 4
oracle.jdbc.driver.T2CStatement.t2cDefineFetch 3
pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doBidItem 1
pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doGetMyData 1
pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doShowUser 4
oracle.jdbc.driver.T2CStatement.t2cParseExecuteDescribe 9
com.mchange.v2.resourcepool.BasicResourcePool.awaitAvailable 78
```

It means that 2 threads are running method `pl.zxspeccy.soapapi.stubs.ServiceServiceStub.doGetItemsList`


#Usage
Count interesting threads in stacktraces from file:
`awk -f jstack-counter.awk stack-traces.jtdp`

Count interesting threads in running process with pid 23344:
`jstack -l 23344 | awk -f jstack-analyzer.awk`


*Don't forget to change definition of interesting threads to your packages*:
/pl\.zxspeccy|oracle\.jdbc|com\.mchange\.v2/
