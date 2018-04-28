MolueSafty
===========
### MolueSafty Architecture

#### MolueSafty
App的主工程，负责管理`AppDelegate`的生命周期和第三方服务的注册等
#### MolueCommon
App业务层中的共用模块,主要负责比如`Encryption`, `Permissions`, `AppDocument` 等,主要为业务层提供服务
#### MolueDatabase
App的数据存储层, 提供给整个App的业务层提供数据存储和读取的**API**
#### MolueNetwork
App的网络数据层, 提供给整个App的业务层提供与后台数据对接的**API**
#### MolueNavigator
App的路由层, 负责控制整个App中各个业务模块的页面跳转
#### MolueFoundation
App的基类和协议层,负责给整个App的业务模块提供基类和协议
#### MolueUtilities
App的工具层,提供给整个App服务,比如常用类型的`Extension`,`Logger`,`NameSpace`,`GCDAsync` 等





