//
//  MLTextUtils.h
//  jobSearch
//
//  Created by RAY on 15/3/10.
//  Copyright (c) 2015年 麻辣工作室. All rights reserved.
//

#ifndef jobSearch_MLTextUtils_h
#define jobSearch_MLTextUtils_h

//数据解析
#define ANALYZE_ERROR @"数据出错啦！请重新尝试"
#define BASE_QUERY_ERROR @"查询失败"
#define BASE_OK @"查询成功"
#define BASE_CREATE_ERROR @"创建失败"
#define BASE_INVALID_INPUT @"输入错误"
#define BASE_INVALID_USER @"用户信息错误，无该用户"

//反馈
#define FEEDBACK_SUCCESS @"反馈提交成功"
#define FEEDBACK_FAIL @"反馈提交失败"
#define FEEDBACK_ALERT @"请您先填写反馈意见哦"

//简历编辑
#define ALERTVIEW_TITLE @"提示"
#define CHANGEPHONEALERT @"修改手机号后登录账户名也会改变，是否要修改？"
#define ALERTVIEW_OKBUTTON @"确定"
#define ALERTVIEW_CANCELBUTTON @"取消"
#define ALERTVIEW_PHONEWRONG @"电话号码错误"
#define ALERTVIEW_KNOWN @"知道了"
#define ALERTVIEW_CAMERAWRONG @"无法使用照相功能"
#define ALERTVIEW_WRITETOFILEWRONG @"写入文件夹错误,请重试"
#define NOVEDIO @"您还没有录制视频介绍哦"
#define VEDIOVCTITLE @"我的视频介绍"
#define UPLOADSUCCESS @"上传成功"
#define UPLOADFAIL @"上传失败"
#define CAMERANOTALLOW @"您没有允许本应用使用相机"
#define OPENCAMERA @"请在设置中开启相机功能"
#define REMUMEUPDATESUCCESS @"简历更新成功"
#define FILLRESUMENOW @"立刻填写"

//登录注册
#define NOTLOGIN @"未登录"
#define ASKTOLOGIN @"是否现在登录？"
#define LOGIN @"登录"
#define ENTERPHONE @"请输入手机号码"
#define ENTERPASSWORD @"请输入登陆密码"
#define LOGINSUCCESS @"登录成功"
#define REGISTERSUCCESS @"注册成功"
#define TOUCHLOGOUT @"点击退出"
#define MESSAGESENTSUCCESS @"验证码已发送"
#define MESSAGESENTFAIL @"验证码获取失败"
#define MESSAGELIMIT @"验证码申请次数超限"
#define MESSAGENOTALLOW @"对不起，你的操作太频繁啦"
#define VERIFYCODEWRONG @"验证码错误"
#define NOTAGREE @"您未同意用户使用协议"
#define PASSWORDNOTSAME @"两次输入密码不一致"
#define ENTERVERIFYCODE @"请输入手机验证码"
#define PHONEWRONG @"手机号码不正确"
#define PASSWORDEDITSUCCESS @"修改成功"
#define ENTERPHONEANDCODE @"请输入正确的手机号和验证码"

//我的申请
#define NOMOREDATA @"没有更多数据啦"
#define NOAPPLYDATA @"您没有申请记录哦"

//我的收藏
#define NOCOLLECTIONDATA @"您没有收藏记录哦"

//职位详情界面
#define CALLENTERPRISE @"打电话给企业"
#define MESSAGEENTERPRISE @"发短信给企业"
#define ENTERPRISENOPHONE @"该企业暂未提供联系方式"
#define APPLYSUCCESS @"申请成功"
#define SHARESUCCESS @"分享成功"
#define SHAREFAIL @"分享失败"
#define COLLOTESUCCESS @"收藏成功"

//首页
#define NEARBYJOB @"附近的职位"
#define LOCATIONFAIL @"定位失败"
#define CHECKLOCATION @"请检查是否已打开定位功能"
#define ENTERKEYWORD @"请输入关键字"
#define DOWNLOADFAIL @"信息加载失败"
#define NOMATCHJOB @"没有找到匹配的职位哦"

//消息
#define NONEWMESSAGE @"您没有新消息哦"

//推荐
#define REFUSEJOB @"成功拒绝职位"
#define ACCEPTJOB @"成功接受职位"

//网络连接
#define NETERROR @"网络连接异常"
#define NETRECOVER @"网络连接已恢复"

//视频
#define VEDIOTIMEOUT @"视频加载超时"
#define NONET @"当前无网络"
#define NOTVIAWIFI @"当前使用手机网络，是否上传"
#define networkError @"请查看网络连接是否正常"
#endif

//buid时取消所有控制台输出
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...){}
#endif
