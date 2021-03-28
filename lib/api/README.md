## 这里是网络接口层相关操作

#### `app_exception.dart`

  app 在请求过程中可能发生的异常做了个自定义封装


#### `app_response.dart`

  对dio响应体做统一处理（当然也可以用dio拦截器做）


#### `custom_dio.dart`

  继承自 Dio 修改了一些配置


#### `dio_client.dart`

  封装了 get，post，put... 等方法


#### provider

  提供数据的，这里放比如， user.dart(用户相关)...,  


#### interceptors

  存放 Dio 的拦截器，需要在 services/dio_config_service.dart 中添加拦截器

#### `README.md`

  目录自述