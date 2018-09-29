<%@page contentType="text/html;charset=UTF-8" language="java"
	pageEncoding="utf-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cp" value="${pageContext.request.contextPath}" />
<%
	String path = request.getContextPath();
	String basePath = request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title>WithMe</title>
<link href="${cp}/img/logo.ico" rel="icon" type="image/x-ico">
<link href="${cp}/css/bootstrap.min.css" rel="stylesheet">
<link href="${cp}/css/animate.css" rel="stylesheet">
<link href="${cp}/css/style.css" rel="stylesheet">
<link href="${cp}/css/main-style.css" rel="stylesheet">

<script src="${cp}/js/jquery.js" type="text/javascript"></script>
<script src="${cp}/js/jquery.min.js" type="text/javascript"></script>
<script src="${cp}/js/bootstrap.min.js" type="text/javascript"></script>
<script src="${cp}/js/layer.js" type="text/javascript"></script>
<%--  <script src="${pageContext.request.contextPath}/static/js/sockjs.js" type="text/javascript"></script> --%>
<script src="${pageContext.request.contextPath}/resources/sockjs.js"
	type="text/javascript"></script>
</head>
<body>
	<div class="icon">
		<a id="listRelation" onclick="listRelation();"> <img width="60px"
			height="60px" src="${cp}/img/icon.png" alt="面板">
		</a>
	</div>

	<script type="text/javascript">
		//获取服务端地址
		var ws = null;
		var path = '<%=basePath%>';
		ws = "ws://" + path + "ws?uid=${currentUser.id}";
		//ws://" + path + "/ws?uid="+uid
		//ws = 'ws://' + window.location.host + '/${currentUser.id}';
		//websocket = new WebSocket("ws://127.0.0.1:8080/SSMTest/echo");
		var websocket = null;

		//判断当前浏览器是否支持WebSocket
		if ('WebSocket' in window) {
			websocket = new WebSocket(ws);
		} else {
			layer.alert('对不起，你的浏览器不支持WebSocket', {
				icon : 2
			});
		};

		//连接成功建立的回调方法
		websocket.onopen = function() {
			//显示在线状态
			//通知自己的所有好友自己上线啦
			onLineStatusNotice(3);
		};

		//接收到消息的回调方法
		websocket.onmessage = function(event) {
			//alert("接受消息回调");
			//接收到消息，处理消息   回调函数
			handleReceiveMessage(event.data);
		};

		//连接发生错误的回调方法
		websocket.onerror = function() {
			//连接关闭，告诉所有好友我下线啦
			onLineStatusNotice(4);
			reconnect();
		};

		//连接关闭的回调方法
		websocket.onclose = function() {
			//连接关闭，告诉所有好友我下线啦
			onLineStatusNotice(4);
			reconnect();
		};
		//		//监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
		//		window.onbeforeunload = function() {
		//			closeWebSocket();
		//		};

		//		//关闭WebSocket连接
		//		function closeWebSocket() {
		//			websocket.close();
		//		}
		// "message"{
		//			"from": "xxxx",
		//			"to":["xxx"],
		//			"content":"xxxxx",
		//			"type":0,
		//			"time":"xxxx.xx.xx xx.xx.xx"
		//		}

		//处理接收到的数据    JSON.stringify(
		function handleReceiveMessage(message) {
			messages = JSON.parse(message);
			//判断是否为上下线通知     这里 有 个 不好之处  不是  每时每刻都在刷新 好友列表      
			if (messages.type == 3 || messages.type == 4) {
				changeToOnlineStatus(messages.content, messages.from,
						messages.to, messages.type, messages.time, message);
			}
			//
			else if (messages.type == 5 || messages.type == 6) {
				openRelationApply(messages.content, messages.from, messages.to,
						messages.type, messages.time, message);
			}
			//  0  私聊-1  是  消息通知
			else if (messages.type == 0 || messages.type == -1||messages.type == 1) {
				showReceiveMessage(messages.content, messages.from,
						messages.to, messages.type, messages.time, message);
			}
			/* else if (messages.type == 1) {
				showGroupReceiveMessage(messages.content, messages.from,
						messages.to, messages.type, messages.time, null);
			} */
		}

		//发送消息
		function sendMessage(content, usersId, type) {
			//alert("发送消息对象" + usersId);
			websocket.send(JSON.stringify({
				from : "${currentUser.id}",
				to : usersId,
				content : content,
				type : type,
				time : getDateFull()
			}));
		}

		//将消息显示在网页上
		function showReceiveMessage(content, from, to, type, time, message) {
			//alert(to);
			//var times = time.split(' ');
			var now = getDateFull();
			var nows = now.split(' ');
			//var showTime = times[1];
			var showTime = time;
			/* if(nows[0]!=times[0]){
				showTime = time;
			} */
			//bug  1 每点击一次 都获取一次记录  且  只能看到对面  回答的 记录
			if (from == "${currentUser.id}") {
				var messageReceiver = '#' + to + 'output';
				var target = document.getElementById(to + 'output');
				if (type == 1) {
					messageReceiver = '#' + to + 'outputGroup';
					target = document.getElementById(to + 'outputGroup');
				}
				var rightArrow = '<div class="row singleMessage">'
						+ '<div class="col-md-11 col-sm-11 col-xs-11 col-lg-11 text">'
						+ '<div class="col-md-12 col-sm-12 col-xs-12 col-lg-12 timePositionRight">'
						+ '<div id="time" class="timeRight">'
						+ showTime
						+ '</div>'
						+ '</div>'
						+ '<div class="arrowBoxRight">'
						+ '<div class="message">'
						+ content
						+ '</div>'
						+ '</div>'
						+ '</div>'
						+ '<div id="icons" class="col-md-1 col-sm-1 col-xs-1 col-lg-1  iconsRight">'
						+ '<img class="img-circle iconssRight" src="img/photo.jpg">'
						+ '</div>' + '</div>';
				if (target) { //如果没有打开那个 弹框  滚动通知
					$(messageReceiver).append(rightArrow);
					target.scrollTop = target.scrollHeight;
				} else {
					if (to) //非空
						doMessageNotice(content, from, to, type, time, message);
				}
			} else {
				//从他处发来 
				var messageReceiver = '#' + from + 'output';
				var target = document.getElementById(from + 'output');
				if (type == 1) {
					messageReceiver = '#' + to + 'outputGroup';
					target = document.getElementById(to + 'outputGroup');
					var fromUser = null;
					var findUser = {};
					findUser.userId = from;
					$.ajax({
						async : false, //设置同步
						type : 'POST',
						url : '${cp}/doFindUserById',
						data : findUser,
						dataType : 'json',
						success : function(resoult) {
							if (resoult.userId != null) {
								fromUser = resoult;
							} else {
								layer.alert('查询错误');
							}
						},
						error : function(resoult) {
							layer.alert('查询错误');
						}
					});
					showTime = fromUser.userNickName + '&nbsp;&nbsp;'
							+ showTime;
				}

				leftArrow = '<div class="row singleMessage">'
						+ '<div id="icons" class="col-md-1 col-sm-1 col-xs-1 col-lg-1  iconsLeft">'
						+ '<img class="img-circle iconssLeft" src="img/photo.jpg">'
						+ '</div>'
						+ '<div class="col-md-11 col-sm-11 col-xs-11 col-lg-11 text">'
						+ '<div class="col-md-12 col-sm-12 col-xs-12 col-lg-12 timePositionLeft">'
						+ '<div class="timeLeft">' + showTime + '</div>'
						+ '</div>' + '<div class="arrowBoxLeft">'
						+ '<div id="leftMessage" class="message">' + content
						+ '</div>' + '</div>' + '</div>' + '</div>';
				if (target) {
					$(messageReceiver).append(leftArrow);
					target.scrollTop = target.scrollHeight;
				} else {
					alert("doMessageNotice  to======="+ to);
					doMessageNotice(content, from, to, type, time, message);
				}

			}
		}

		var noticeIndex = null;
		var noticeUser = new Array();
		var noticeMessage = new Array();
		var noticeCount = 0;
		var statusChangeMark = 0;

		//消息通知  显示 
		function doMessageNotice(content, from, to, type, time, message) {
			var fromUser = null;
			var findUser = {};
			findUser.userId = from;
			//显示再次   确认 目标 是否存在
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/doFindUserById',
				data : findUser,
				dataType : 'json',
				success : function(resoult) {
					if (resoult.userId != null) {
						fromUser = resoult;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});

			if (noticeIndex == null) {
				var html = '<div class="notice">'
						+ '<div class="noticePosition" onclick="openNotice();">'
						+ '<marquee id="noticeText">' + '</marquee>' + '</div>'
						+ '</div>';
				noticeIndex = layer.open({
					type : 1,
					title : false,
					closeBtn : 0,
					content : html,
					shade : 0,
					offset : 't',
					area : [ '180px', '40px' ],
					anim : 6,
					id : 'notice'
				});
			}
			if (type == 0 || type == -1 || type == 1) {
				noticeUser[noticeCount] = fromUser;
				noticeMessage[noticeCount] = message;
				noticeCount++;
			}
			var noticeText = document.getElementById('noticeText');
			//这里也遇到了一个坑，哎。因为之前这里没有传type这个参数，所以这里判断的时候不会生效，那么提示区的文本自然就空掉了
			//不多说，都是泪。下次注意这种错误。
			var text = '';
			if (type == 0 || type == -1) {
				text += fromUser.userNickName + ':' + content;
			} else if (type == 3) {
				text = '您的联系人&nbsp;' + fromUser.userNickName + '&nbsp;上线了';
				statusChangeMark = 1;
			} else if (type == 4) {
				text = '您的联系人 &nbsp;' + fromUser.userNickName + '&nbsp;下线了';
				statusChangeMark = 1;
			} else if (type == 1) {
				//alert("通知群组id" + to);
				var group = ajaxGetGroupById(to);
				text = group.groupName + '|' + fromUser.userNickName + ':'
						+ content;
			}
			text += '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
			noticeText.innerHTML += text;
		}

		//打开聊天弹框
		function openNotice(content, from, to, time) {
			layer.close(noticeIndex);
			if (statusChangeMark == 1) {
				listRelation();
			}
			for (var i = 0; i < noticeCount; i++) {
				var messages = JSON.parse(noticeMessage[i]);
				if (messages.type == 0 || messages.type == -1) {
					chatWithSomeBody(noticeUser[i].userId,
							noticeUser[i].userName, noticeUser[i].userNickName);
				} else if (messages.type == 1) {
					var group = ajaxGetGroupById(messages.to);
					chatWithGroup(group.id, group.groupId, group.groupName,
							group.groupCreaterId);
				}
			}
			noticeIndex = null;
			noticeUser.splice(0, noticeUser.length);
			noticeMessage.splice(0, noticeMessage.length);
			noticeCount = 0;
			statusChangeMark = 0;
		}

		function appendZero(s) {
			return ("00" + s).substr((s + "").length);
		} //补0函数

		//获取当前时间日期
		function getDateFull() {
			var date = new Date();
			var currentdate = date.getFullYear() + "-"
					+ appendZero(date.getMonth() + 1) + "-"
					+ appendZero(date.getDate()) + " "
					+ appendZero(date.getHours()) + ":"
					+ appendZero(date.getMinutes()) + ":"
					+ appendZero(date.getSeconds());
			return currentdate;
		}

		function closeWindow() {
			window.opener = null;
			window.open('', '_self');
			window.close();
		}

		layer.ready(function() {
			listRelation();
		});

		//使用ajax获取当前用户的所有好友，
		//现在大概知道json转来转去的过程了，上面两处使用ajax不太规范，但是改着太麻烦就不改了，能用就成
		function getAllRelations() {
			var allRelations = null;
			var currentUser = {};
			currentUser.userId = "${currentUser.id}";
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/getRelations',
				data : currentUser,
				dataType : 'json',
				success : function(resoult) {
					if (resoult != null) {
						allRelations = resoult.relations;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});
			//划重点划重点，这里的eval方法不同于prase方法，外面加括号
			allRelations = eval("(" + allRelations + ")");
			return allRelations;
		}

		function onLineStatusNotice(type) {
			var allRelations = getAllRelations();
			//alert( JSON.stringify(allRelations));
			var content = null;
			if (type == 3)
				content = '上线通知';
			else if (type == 4)
				content = '下线通知';
			var usersId = new Array();
			var data = {};
			for (var i = 0; i < allRelations.length; i++) {
				//向每一位好友发送你  登录  或者 下线的 消息
				sendMessage(content, allRelations[i].id, type);
			}
			//sendMessage(content,1,type);
		}

		function changeToOnlineStatus(content, from, to, type, time, message) {
			var onLineStatus = document.getElementById(from + 'onlineStatus');
			var offLineStatus = document.getElementById(from + 'offlineStatus');
			//判断如果找不到这个id，那么和普通消息一样放入缓存区
			if (onLineStatus && type == 3) {
				onLineStatus.style.opacity = 1;
				offLineStatus.style.opacity = 0;
			} else if (offLineStatus && type == 4) {
				onLineStatus.style.opacity = 0;
				offLineStatus.style.opacity = 1;
			} else {
				doMessageNotice(content, from, to, type, time, message);
			}
		}

		//列出好友列表
		var relationListIndex = null;
		function listRelation() {
			var allRelations = getAllRelations();
			var allGroups = getUserAllGroups();
			var html = '<div id="relationList" class="relation">'
					+ '<div class="lists">'
					+ '<ul class="nav nav-tabs">'
					+ '<li class="active justifile text-center">'
					+ '<a href="#relationPeople" data-toggle="tab">'
					+ '联系列表'
					+ '</a>'
					+ '</li>'
					+ '<li class="justifile text-center">'
					+ '<a href="#groupPeople" data-toggle="tab">'
					+ ' 群列表'
					+ '</a>'
					+ '</li>'
					+ '</ul>'
					+ '<div class="tab-content">'
					+ '<div class="tab-pane fade in active" id="relationPeople">';
			for (var i = 0; i < allRelations.length; i++) {
				//注意！注意！注意！onclick后面调用的function里面的参数如果是字符串只能用单引号！！！！只能用单引号！
				//血和泪的教训搞了好久才改过来这里的错误，哎。之前使用单引号对了，这里改成ajax时因为字符串拼接是单引号所以里面就用了双引号，结果一直错错错，而且还不说错哪儿了，哎
				//现在想想也是，虽然js里面字符串单引号双引号都行，但是在html里面添加参数就不一样了！对于html来讲双引号是一个标签属性开始与结束的标志，而单引号没有意义，
				//所以如果这里用了双引号会引起html语意混淆，单引号则没有问题，记笔记，记笔记。（js拼接字符串时使用\+字符，这个字符就会作为普通的字符串被拼接上啦！不会被认为是有特殊含义的）
				html += '<div class="relationSingle" onclick="chatWithSomeBody('
						+ allRelations[i].id
						+ ',\''
						+ allRelations[i].userName
						+ '\',\''
						+ allRelations[i].userNickName
						+ '\');">'
						+ '<div class="photoBox">'
						+ '<img class="img-circle photo" src="${cp}/img/photo.jpg">'
						+ '</div>'
						+ '<div id="currentNickName" class="list">'
						+ allRelations[i].userNickName
						+ '</div>'
						+ '<div id="'+allRelations[i].id+'onlineStatus" class="onlineStatus">'
						+ '在线'
						+ '</div>'
						+ '<div id="'+allRelations[i].id+'offlineStatus" class="offlineStatus">'
						+ '离线'
						+ '</div>'
						+ '<div class="recent">'
						+ '</div>'
						+ '</div>';

			}
			html += '</div>' + '<div class="tab-pane fade" id="groupPeople">';
			for (var i = 0; i < allGroups.length; i++) {
				html += '<div class="relationSingle" onclick="chatWithGroup('
						+ allGroups[i].id
						+ ',\''
						+ allGroups[i].groupId
						+ '\',\''
						+ allGroups[i].groupName
						+ '\','
						+ allGroups[i].groupCreaterId
						+ ');">'
						+ '<div class="photoBox">'
						+ '<img class="img-circle photo" src="${cp}/img/photo.jpg">'
						+ '</div>' + '<div class="list">'
						+ allGroups[i].groupName + '</div>'
						+ '<div class="recent">' + '</div>' + '</div>';
			}
			html += '</div>'
					+ '</div>'
					+ '</div>'
					+ '<div class="functions">'
					+ '<div class="btn-group btn-group-justified">'
					+ '<div class="btn-group">'
					+ '<button type="button" class="btn btn-default" onclick="searchFriend();">添加好友</button>'
					+ '</div>'
					+ '<div class="btn-group">'
					+ '<button type="button" class="btn btn-default" onclick="test();">测试</button>'
					+ '</div>'
					+ '<div class="btn-group">'
					+ '<button type="button" class="btn btn-default">待定</button>'
					+ '</div>'
					+ '<div class="btn-group">'
					+ '<button type="button" class="btn btn-default" onclick="createGroup()">创建群</button>'
					+ '</div>' + '</div>' + '</div>' + '</div>';
			relationListIndex = layer
					.open({
						type : 1,
						skin : 'layer-ext-lists',
						title : [ '${currentUser.userNickName}',
								'font-family:Microsoft YaHei;font-size: 24px;height: 80px;' ],
						closeBtn : 1,
						content : html,
						area : [ '300px', '600px' ],
						offset : 'rb',
						anim : 2,
						id : 'relationList',
						shade : 0,
						zIndex : layer.zIndex,
						success : function(layero) {
							layer.setTop(layero);
						}
					});
			for (var i = 0; i < allRelations.length; i++) {
				var onLineStatus = document.getElementById(allRelations[i].id
						+ 'onlineStatus');
				var offLineStatus = document.getElementById(allRelations[i].id
						+ 'offlineStatus');
				if (allRelations[i].userIsOnline == 0) {
					onLineStatus.style.opacity = 0;
					offLineStatus.style.opacity = 1;
				} else {
					onLineStatus.style.opacity = 1;
					offLineStatus.style.opacity = 0;
				}
			}
		}
		//搜索/添加好友  
		//
		function searchFriend() {
			layer.prompt({
				title : '请输入用户名：',
				zIndex : 20000000
			}, function(userName, index) {
				layer.close(index);
				findUser(userName);
			});

		}

		//查找该用户是否存在
		function findUser(userName) {
			var findUser = {};
			findUser.userName = userName;
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/doFindUserByName',
				data : findUser,
				dataType : 'json',
				success : function(resoult) {
					if (resoult.userId != null) {
						addFriend(resoult.userId, resoult.userName,
								resoult.userNickName);
					} else {
						layer.msg('查找的人不存在', {
							icon : 6,
							zIndex : 20000001,
							time : 2000
						});
					}
				},
				error : function(resoult) {
					layer.msg('查找失败', {
						icon : 6,
						zIndex : 20000001,
						time : 2000
					});
				}
			});
		}

		var addFriendIndex = null;
		function addFriend(userId, userName, userNickName) {
			var html = '<div id="addFriend" class="addFriend">'
					+ '<div class="container addFriendBox">'
					+ '<div class="row addFriendRow">'
					+ '<div class="col-md-5 col-sm-5 col-xs-5 col-lg-5 addFriendImgBox">'
					+ '<img src="img/photo.jpg" class="img-circle addFriendImg">'
					+ '</div>'
					+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
					+ '用&nbsp;&nbsp;户&nbsp;&nbsp;名：'
					+ userName
					+ '</div>'
					+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
					+ '昵&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称：'
					+ userNickName
					+ '</div>'
					+ '<div class="col-md-6 col-sm-6 col-xs-6 col-lg-6 addFriendInfo">'
					+ '附加消息：'
					+ '<textarea id="addFriendMessage" class="form-control addFriendTextArea" rows="2"></textarea>'
					+ '</div>'
					+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
					+ '<button class="btn btn-default" onclick=\'addThisUser('
					+ userId + ')\'>建立联系</button>' + '</div>' + '</div>'
					+ '</div>' + '</div>';
			addFriendIndex = layer.open({
				type : 1,
				title : '查找结果',
				content : html,
				area : [ '500px', '275px' ],
				resize : false,
				id : 'addFriend',
				zIndex : 20000001
			});
		};

		//建立 好友  联系      建立联系
		function addThisUser(userId) {
			var text = document.getElementById('addFriendMessage').value;
			/* var usersId = new Array();
			usersId[0] = userId; */
			//同步发布   添加  好友    消息  
			sendMessage(text, userId, 5);
			layer.close(addFriendIndex);
		}

		//好友申请数
		var relationApply = null;
		var relationApplyNumber = 0;

		//同意好友添加
		function agreeAddThisUser(userId) {
			var text = '';
			var addUser = {};
			addUser.userIdA = userId;
			addUser.userIdB = "${currentUser.id}";
			//设置为同步后    那边有反应后 才能  加入
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/buildRelation',
				data : addUser,
				dataType : 'json',
				success : function(resoult) {
					if (resoult.resoult == 'success') {
						text = '我已经同意了你的好友申请，快一起来搞点事情吧！';
					} else {
						text = '是上天不允许我们建立联系啊！';
					}
				},
				error : function(resoult) {
					layer.msg('添加失败', {
						icon : 6,
						zIndex : 20000001,
						time : 2000
					});
				}
			});
			/* var usersId = new Array();
			usersId[0] = userId; */
			//发送   同意  的消息过去
			sendMessage(text, userId, -1);

			var addFriendRow = document.getElementById(userId + 'addFriendRow');

			//关闭同意  添加按钮   弹框  
			//addFriendRow.style.display = 'none';
			relationApplyNumber--;
			if (relationApplyNumber == 0)
				layer.close(relationApply);

			// 刷新好友列表
			/* var relationList = document.getElementById('relationList');
			if(relationList){
				layer.close(relationListIndex);
			}   */

		}

		//拒绝好友添加
		function refuseAddThisUser(userId) {
			//var text = '落花有意，流水无情。相见想闻，不如不见不闻。';
			var text = '系统抛了一枚硬币，觉得你俩不合适，所以驳回了你的申请。';
			/* var usersId = new Array();
			usersId[0] = userId; */
			sendMessage(text, userId, -1);
			var addFriendRow = document.getElementById(userId + 'addFriendRow');
			addFriendRow.style.display = 'none';
			relationApplyNumber--;
			if (relationApplyNumber == 0)
				layer.close(relationApply);
		}

		//添加 好友  后    另一方 选择 同意 还是 拒绝
		function openRelationApply(content, from, to, type, time, message) {
			var fromUser = null;
			var findUser = {};
			findUser.userId = from;
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/doFindUserById',
				data : findUser,
				dataType : 'json',
				success : function(resoult) {
					if (resoult.userId != null) {
						fromUser = resoult;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});
			var addFriendApply = document.getElementById('addFriendApply');
			if (!addFriendApply) {
				var html = '<div id="addFriendApply" class="addFriend">'
						+ '<div id="friendApplyBox" class="container addFriendBox">'
						+ '</div>' + '</div>';
				relationApply = layer.open({
					type : 1,
					title : '系统消息',
					content : html,
					area : [ '500px', '275px' ],
					shade : 0,
					resize : false,
					zIndex : layer.zIndex,
					success : function(layero) {
						layer.setTop(layero);
					}
				});
			}
			relationApplyNumber++;
			if (type == 5)
				var friendApplyHtml = '<div id="'+from+'addFriendRow" class="row addFriendRow">'
						+ '<div class="col-md-5 col-sm-5 col-xs-5 col-lg-5 addFriendImgBox">'
						+ '<img src="img/photo.jpg" class="img-circle addFriendImg">'
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ '用&nbsp;&nbsp;户&nbsp;&nbsp;名：'
						+ fromUser.userName
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ '昵&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;称：'
						+ fromUser.userNickName
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ '附加消息：'
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ content
						+ '</div>'
						+ '<div class="col-md-3 col-sm-3 col-xs-3 col-lg-3 addFriendInfo">'
						+ '<button class="btn btn-default" onclick=\'agreeAddThisUser('
						+ from
						+ ')\'>加了这货</button>'
						+ '</div>'
						+ '<div class="col-md-3 col-sm-3 col-xs-3 col-lg-3 addFriendInfo">'
						+ '<button class="btn btn-default" onclick=\'refuseAddThisUser('
						+ from + ')\'>残忍拒绝</button>' + '</div>' + '</div>';
			else if (type == 6) {
				var group = ajaxGetGroupById(content);
				friendApplyHtml = '<div id="'+group.id+'addFriendRow" class="row addFriendRow">'
						+ '<div class="col-md-5 col-sm-5 col-xs-5 col-lg-5 addFriendImgBox">'
						+ '<img src="img/photo.jpg" class="img-circle addFriendImg">'
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ '群&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;号：'
						+ group.groupId
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ '群&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;名：'
						+ group.groupName
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ '类型：入群邀请'
						+ '</div>'
						+ '<div class="col-md-7 col-sm-7 col-xs-7 col-lg-7 addFriendInfo">'
						+ '邀请人：'
						+ fromUser.userNickName
						+ '</div>'
						+ '<div class="col-md-3 col-sm-3 col-xs-3 col-lg-3 addFriendInfo">'
						+ '<button class="btn btn-default" onclick=\'agreeGroupInvite('
						+ content
						+ ')\'>进去看看</button>'
						+ '</div>'
						+ '<div class="col-md-3 col-sm-3 col-xs-3 col-lg-3 addFriendInfo">'
						+ '<button class="btn btn-default" onclick=\'refuseGroupInvite('
						+ content + ')\'>不感兴趣</button>' + '</div>' + '</div>';
			}
			var friendApplyBox = document.getElementById('friendApplyBox');
			friendApplyBox.innerHTML += friendApplyHtml;
		}

		// ajax获取两用户之间的消息记录
		//参数是  目标userId
		function getMessageRecordBetweenUsers(userId) {
			var allMessages = null;
			var twoUser = {};
			twoUser.userIdA = "${currentUser.id}";
			twoUser.userIdB = userId;
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/getMessageRecordBetweenUsers',
				data : twoUser,
				//服务器返回的数据类型
				dataType : 'json',
				success : function(resoult) {
					if (resoult != null) {
						allMessages = resoult.resoult;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});
			//划重点划重点，这里的eval方法不同于prase方法，外面加括号
			allMessages = eval("(" + allMessages + ")");
			return allMessages;
		}

		//单人聊天窗口
		function chatWithSomeBody(userId, userName, userNickName) {

			var chatWith = '<div class="chatWith">'
					+ '<div id="'+userId+'output" class="container output">'
					+ '</div>'
					+ '<hr/>'
					+ '<div class="options">'
					+ '<img class="option" src="${cp}/img/face.png">'
					+ '<img class="option" src="${cp}/img/img.png">'
					//showReceiveMessage(content, from, to, type, time, message)
					+ '<button type="button" class="btn btn-default pull-right" onclick="sendMessagePre('
					+ userId
					+ ')">发送</button>'
					+ '</div>'
					+ '<div class="input">'
					+ '<textarea id="'
					+ userId
					+ 'messageText" class="form-control" onkeydown="binfEnter(event,'
					+ userId + ')"></textarea>' + '</div>' + '</div>';

			layer
					.open({
						type : 1,
						title : [ userNickName,
								'font-family:Microsoft YaHei;font-size: 24px;height: 80px;' ],
						content : chatWith,
						area : [ '600px', '600px' ],
						maxmin : true,
						offset : [ '100px', '100px' ],
						shade : 0,
						id : userName,
						resize : true,
						zIndex : layer.zIndex,
						success : function(layero) {
							layer.setTop(layero);
						}
					});

			//获取消息记录

			var allMessages = getMessageRecordBetweenUsers(userId);
			//  alert(JSON.stringify(allMessages));
			for (var i = 0; i < allMessages.length; i++) {
				var jsonMessage = JSON.stringify({
					from : allMessages[i].from,
					to : allMessages[i].to,
					content : allMessages[i].content,
					type : allMessages[i].type,
					time : allMessages[i].time
				});
				
				showReceiveMessage(allMessages[i].content, allMessages[i].from,
						allMessages[i].to, allMessages[i].type,
						allMessages[i].time, jsonMessage);
			}

		}
		//监听输入框回车键
		function binfEnter(obj, toUserId) {
			if (obj.keyCode == 13) {
				sendMessagePre(toUserId);
				obj.preventDefault();
			}
		}

		//发送消息                    传递准备工作
		function sendMessagePre(toUserId) {
			//  alert("发送消息:"+toUserId);
			var content = $("#" + toUserId + "messageText").val();//
			var from = "${currentUser.id}";
			var type = 0;
			// alert(content);
			// 页面  显示出来
			showReceiveMessage(content, from, toUserId, type, getDateFull(),
					null);
			var twoUser = {};
			twoUser.userIdA = "${currentUser.id}";
			twoUser.userIdB = toUserId;
			twoUser.content = content;
			twoUser.type = type;
			//twoUser.time=getDateFull(); 

			//alert(getDateFull());
			//消息存入数据库  数据库 
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/addMessage',
				data : twoUser,
				//服务器返回的数据类型
				dataType : 'json',
				success : function(resoult) {
					if (resoult != null) {
						allMessages = resoult.resoult;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});

			var textAreaId = toUserId + 'messageText';
			var message = document.getElementById(textAreaId).value;
			if (message != '') {
				//var toUsersId = new Array();
				//toUsersId[0] = toUserId;
				sendMessage(message, toUserId, 0);
				document.getElementById(textAreaId).value = '';
			}
		}

		//下面是关于群组的窗口和操作
		//获取某人的所有群
		function getUserAllGroups() {
			var allGroups = null;
			var currentUser = {};
			currentUser.userId = "${currentUser.id}";
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/getUserGroups',
				data : currentUser,
				dataType : 'json',
				success : function(resoult) {
					if (resoult != null) {
						allGroups = resoult.groups;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});
			//划重点划重点，这里的eval方法不同于prase方法，外面加括号
			allGroups = eval("(" + allGroups + ")");
			return allGroups;
		}

		//获取某群的所有人
		//json请求
		function getGroupAllUsers(id) {
			var usersAndUserGroup = {};
			var currentGroup = {};
			currentGroup.id = id;
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/getGroupUsers',
				data : currentGroup,
				dataType : 'json',
				success : function(resoult) {
					if (resoult != null) {
						usersAndUserGroup.userGroups = resoult.userGroups;
						usersAndUserGroup.users = resoult.users;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});
			usersAndUserGroup.userGroups = eval("("
					+ usersAndUserGroup.userGroups + ")");
			usersAndUserGroup.users = eval("(" + usersAndUserGroup.users + ")");
			return usersAndUserGroup;
		}

		//创建群的窗口
		var createGroupIndex = null;
		function createGroup() {
			var html = '<div class="createGroup">'
					+ '<div class="container createGroupBox">'
					+ '<div class="row createGroupRow">'
					+ '<div class="col-md-5 col-sm-5 col-xs-5 col-lg-5 createGroupImgBox">'
					+ '<img src="img/photo.jpg" class="img-circle createGroupImg">'
					+ '</div>'
					+ '<div class="col-md-2 col-sm-2 col-xs-2 col-lg-2 createGroupInfo">'
					+ '群&nbsp;&nbsp;名&nbsp;&nbsp;称：'
					+ '</div>'
					+ '<div class="col-md-4 col-sm-4 col-xs-4 col-lg-4 createGroupInfo">'
					+ '<input id="createGroupName" type="text" class="form-control" placeholder="作死小分队">'
					+ '</div>'
					+ '<div class="col-md-6 col-sm-6 col-xs-6 col-lg-6 createGroupInfo">'
					+ '群描述：'
					+ '<textarea id="createGroupIntroduction" class="form-control createGroupTextArea" placeholder="生命不息，作死不止！" rows="2"></textarea>'
					+ '</div>'
					+ '<div class="col-md-6 col-sm-6 col-xs-6 col-lg-6 createGroupInfo">'
					+ '<button class="btn btn-default" onclick="ajaxCreateGroup()">建立群组</button>'
					+ '</div>' + '</div>' + '</div>' + '</div>';
			createGroupIndex = layer.open({
				type : 1,
				title : '创建群组',
				content : html,
				area : [ '500px', '275px' ],
				resize : false,
				zIndex : layer.zIndex,
				success : function(layero) {
					layer.setTop(layero);
				}
			});
		}

		//创建群的操作
		function ajaxCreateGroup() {
			if (createGroupIndex != null) {
				var createGroup = {};
				createGroup.groupName = document
						.getElementById('createGroupName').value;
				createGroup.groupIntroduction = document
						.getElementById('createGroupIntroduction').value;
				createGroup.groupCreaterId = "${currentUser.id}";
				layer.close(createGroupIndex);
				$.ajax({
					async : false, //设置同步
					type : 'POST',
					url : '${cp}/createGroup',
					data : createGroup,
					dataType : 'json',
					success : function(resoult) {
						if (resoult.resoult != null) {
							layer.alert('创建群组成功,你的群id为：' + resoult.resoult);
						} else {
							layer.msg('创建群组失败', {
								icon : 2,
								zIndex : 20000001,
								time : 2000
							});
						}
					},
					error : function(resoult) {
						layer.msg('创建群组发生错误', {
							icon : 2,
							zIndex : 20000001,
							time : 2000
						});
					}
				});
			} else {
				layer.msg('创建群组发出的请求参数不完整，请重新创建', {
					icon : 2,
					zIndex : 20000001,
					time : 2000
				});
			}
		}

		//ajax获取单个用户与群组的聊天记录
		function getMessageRecordBetweenUserAndGroup(id) {
			var allMessages = null;
			var userGroup = {};
			userGroup.userId = "${currentUser.id}";
			userGroup.id = id;
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/getMessageRecordBetweenUserAndGroup',
				data : userGroup,
				dataType : 'json',
				success : function(resoult) {
					if (resoult != null) {
						allMessages = resoult.resoult;
					} else {
						layer.alert('查询错误');
					}
				},
				error : function(resoult) {
					layer.alert('查询错误');
				}
			});
			//划重点划重点，这里的eval方法不同于prase方法，外面加括号
			allMessages = eval("(" + allMessages + ")");
			return allMessages;
		}

		//群组聊天窗口  群组聊天的 id  为 群id
		function chatWithGroup(id, groupId, groupName, groupCreaterId) {
			var chatWith = '<div class="chatWith">'
					+ '<div id="'+id+'outputGroup" class="container output">'
					+ '</div>'
					+ '<hr/>'
					+ '<div class="options">'
					+ '<img class="option" src="${cp}/img/face.png">'
					+ '<img class="option" src="${cp}/img/img.png">'
					+ '<button type="button" class="btn btn-default pull-right" onclick="sendGroupMessagePre('
					+ id
					+ ')">发送</button>'
					+ '<button type="button" class="btn btn-default pull-right smallOffset" onclick="groupUserList('
					+ id + ')">查看群成员</button>';
			if (groupCreaterId == "${currentUser.id}")
				chatWith += '<button type="button" class="btn btn-default pull-right smallOffset" onclick="groupInvite('
						+ id + ')">邀请新成员</button>';
			chatWith += '</div>'
					+ '<div class="input">'
					+ '<textarea id="'
					+ id
					+ 'messageTextGroup" class="form-control" onkeydown="binfEnterGroup(event,'
					+ id + ')"></textarea>' + '</div>' + '</div>';
			layer
					.open({
						type : 1,
						title : [ groupName,
								'font-family:Microsoft YaHei;font-size: 24px;height: 80px;' ],
						content : chatWith,
						area : [ '600px', '600px' ],
						maxmin : true,
						offset : [ '100px', '100px' ],
						shade : 0,
						id : groupId,
						resize : true,
						zIndex : layer.zIndex,
						success : function(layero) {
							layer.setTop(layero);
						}
					});

			
			//获取个人和群组的消息记录
			var allMessages = getMessageRecordBetweenUserAndGroup(id);
			alert(allMessages);
			for (var i = 0; i < allMessages.length; i++) {
				//var usersId = new Array();
				//usersId[0] = id;
				//usersId[1] = allMessages[i].to;
				var jsonMessage = JSON.stringify({
					from : allMessages[i].from,
					to : allMessages[i].to,
					content : allMessages[i].content,
					type : allMessages[i].type,
					time : allMessages[i].time
				});
				alert(jsonMessage);
				
				/* showReceiveMessage(allMessages[i].content, allMessages[i].from,
						allMessages[i].to, allMessages[i].type, allMessages[i].time,
						jsonMessage); */
				showGroupReceiveMessage(id,allMessages[i].content,allMessages[i].from,allMessages[i].to,allMessages[i].type
						,allMessages[i].time,jsonMessage);
			}
		}
		//监听群聊输入框回车键
		function binfEnterGroup(obj, id) {
			if (obj.keyCode == 13) {
				sendGroupMessagePre(id);
				obj.preventDefault();
			}
		}

		function ajaxGetGroupById(id) {
		//	alert("群组id" + id);
			var group = null;
			var groups = {};
			groups.id = id;
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/findGroupById',
				data : groups,
				dataType : 'json',
				success : function(resoult) {
					if (resoult.resoult != null) {
						group = resoult.resoult;
					} else {
						layer.msg('打开群组失败', {
							icon : 2,
							zIndex : 20000001,
							time : 2000
						});
					}
				},
				error : function(resoult) {
					layer.msg('打开群组发生错误', {
						icon : 2,
						zIndex : 20000001,
						time : 2000
					});
				}
			});
			group = eval("(" + group + ")");
			return group;
		}

		//发送群聊消息传递准备工作
		//显示群聊信息  参数id 为群id
		/* function sendGroupMessagePre(id) {
			//发送 端   群组显示 消息
			var content = $("#" + id + "messageTextGroup").val();// textarea 是群组id
			var from = "${currentUser.id}";
			var type = 1;

			var twoUser = {};

			
			

			//获得群组成员
			var group = ajaxGetGroupById(id);
			for (var i = 0; i < allMessages.length; i++) {
				var jsonMessage = JSON.stringify({
					from : allMessages[i].from,
					to : allMessages[i].to,
					content : allMessages[i].content,
					type : allMessages[i].type,
					time : allMessages[i].time
				});
			//通知对象为空的话    群中展示发出的消息
			showGroupReceiveMessage(id, content, from, type, getDateFull(),
					null);
			
			
			var textAreaId = id + 'messageTextGroup';
			var message = document.getElementById(textAreaId).value;
			if (message != '') {
				var toUsersIdString = new Array();
				toUsersIdString = (group.groupMembers).split(',');
				//var toUsersId = new Array();
				//对于群组内每一个用户  这个包括自己   
				for (var i = 0; i < toUsersIdString.length; i++) {
					//除了自己 之外 的 发送消息
					if (toUsersIdString[i] != "${currentUser.id}") {
						//想这个群里发送消息
						sendMessage(message, parseInt(toUsersIdString[i]), 1);

						twoUser.userIdA = "${currentUser.id}";
						twoUser.userIdB = parseInt(toUsersIdString[i]);
						twoUser.content = content;
						twoUser.type = 1;
						//消息存入数据库  数据库 
						$.ajax({
							async : false, //设置同步
							type : 'POST',
							url : '${cp}/addMessageInUserGroup',
							data : twoUser,
							//服务器返回的数据类型
							dataType : 'json',
							success : function(resoult) {
								if (resoult != null) {
									allMessages = resoult.resoult;
								} else {
									layer.alert('查询错误');
								}
							},
							error : function(resoult) {
								layer.alert('查询错误');
							}
						});

					}
				}
				//sendMessage(message, toUsersId ,1);
				document.getElementById(textAreaId).value = '';
			}
		}

		//群组发送 消息 显示  id为群id
		function showGroupReceiveMessage(id, content, from, type, time, message) {
			alert("群组 发送 消息  id:" + id);
			var now = getDateFull();
			var nows = now.split(' ');
			var showTime = time;
			//通知也是循环发
			var group = ajaxGetGroupById(id);
			var textAreaId = id + 'messageTextGroup';
			var message = document.getElementById(textAreaId).value;
			if (message != '') {
				var toUsersIdString = new Array();
				toUsersIdString = (group.groupMembers).split(',');
				if (from == "${currentUser.id}") {
					//messageGroup 只是  输入开给你   outputGroup 是出入后显示框 div
					if (type == 1) {
						messageReceiver = '#' + id + 'outputGroup';
						target = document.getElementById(id + 'outputGroup');
					}
					var rightArrow = '<div class="row singleMessage">'
							+ '<div class="col-md-11 col-sm-11 col-xs-11 col-lg-11 text">'
							+ '<div class="col-md-12 col-sm-12 col-xs-12 col-lg-12 timePositionRight">'
							+ '<div id="time" class="timeRight">'
							+ showTime
							+ '</div>'
							+ '</div>'
							+ '<div class="arrowBoxRight">'
							+ '<div class="message">'
							+ content
							+ '</div>'
							+ '</div>'
							+ '</div>'
							+ '<div id="icons" class="col-md-1 col-sm-1 col-xs-1 col-lg-1  iconsRight">'
							+ '<img class="img-circle iconssRight" src="img/photo.jpg">'
							+ '</div>' + '</div>';
					if (target) { //如果没有打开那个 弹框  滚动通知
						$(messageReceiver).append(rightArrow);
						target.scrollTop = target.scrollHeight;
					} else {

						//var toUsersId = new Array();
						//对于群组内每一个用户  这个包括自己   
						for (var i = 0; i < toUsersIdString.length; i++) {
							doMessageNotice(content, from,
									parseInt(toUsersIdString[i]), type, time,
									message);
						}
					}
				}
			} else {
				if (type == 1) {
					messageReceiver = '#' + id + 'outputGroup';
					target = document.getElementById(id + 'outputGroup');
					var fromUser = null;
					var findUser = {};
					findUser.userId = from;
					$.ajax({
						async : false, //设置同步
						type : 'POST',
						url : '${cp}/doFindUserById',
						data : findUser,
						dataType : 'json',
						success : function(resoult) {
							if (resoult.userId != null) {
								fromUser = resoult;
							} else {
								layer.alert('查询错误');
							}
						},
						error : function(resoult) {
							layer.alert('查询错误');
						}
					});
					showTime = fromUser.userNickName + '&nbsp;&nbsp;'
							+ showTime;
				}

				leftArrow = '<div class="row singleMessage">'
						+ '<div id="icons" class="col-md-1 col-sm-1 col-xs-1 col-lg-1  iconsLeft">'
						+ '<img class="img-circle iconssLeft" src="img/photo.jpg">'
						+ '</div>'
						+ '<div class="col-md-11 col-sm-11 col-xs-11 col-lg-11 text">'
						+ '<div class="col-md-12 col-sm-12 col-xs-12 col-lg-12 timePositionLeft">'
						+ '<div class="timeLeft">' + showTime + '</div>'
						+ '</div>' + '<div class="arrowBoxLeft">'
						+ '<div id="leftMessage" class="message">' + content
						+ '</div>' + '</div>' + '</div>' + '</div>';
				if (target) {
					$(messageReceiver).append(leftArrow);
					target.scrollTop = target.scrollHeight;
				} else {
					for (var i = 0; i < toUsersIdString.length; i++) {
						doMessageNotice(content, from,
								parseInt(toUsersIdString[i]), type, time,
								message);
					}
				}

			}
		} */
  
		function showGroupReceiveMessage(id, content, from,to, type, time, message) {
			var now = getDateFull();
			var nows = now.split(' ');
			var showTime = time;
			
			//bug  1 每点击一次 都获取一次记录  且  只能看到对面  回答的 记录
			if (from == "${currentUser.id}") {
				var messageReceiver = '#' + to + 'output';
				var target = document.getElementById(to + 'output');
				if (type == 1) {
					messageReceiver = '#' + to + 'outputGroup';
					target = document.getElementById(to + 'outputGroup');
				}
				var rightArrow = '<div class="row singleMessage">'
						+ '<div class="col-md-11 col-sm-11 col-xs-11 col-lg-11 text">'
						+ '<div class="col-md-12 col-sm-12 col-xs-12 col-lg-12 timePositionRight">'
						+ '<div id="time" class="timeRight">'
						+ showTime
						+ '</div>'
						+ '</div>'
						+ '<div class="arrowBoxRight">'
						+ '<div class="message">'
						+ content
						+ '</div>'
						+ '</div>'
						+ '</div>'
						+ '<div id="icons" class="col-md-1 col-sm-1 col-xs-1 col-lg-1  iconsRight">'
						+ '<img class="img-circle iconssRight" src="img/photo.jpg">'
						+ '</div>' + '</div>';
				if (target) { //如果没有打开那个 弹框  滚动通知
					$(messageReceiver).append(rightArrow);
					target.scrollTop = target.scrollHeight;
				} else {
					if (to) //非空
						doMessageNotice(content, from, to, type, time, message);
				}
			} else {
				//从他处发来 
				var messageReceiver = '#' + from + 'output';
				var target = document.getElementById(from + 'output');
				if (type == 1) {
					messageReceiver = '#' + to + 'outputGroup';
					target = document.getElementById(to + 'outputGroup');
					var fromUser = null;
					var findUser = {};
					findUser.userId = from;
					$.ajax({
						async : false, //设置同步
						type : 'POST',
						url : '${cp}/doFindUserById',
						data : findUser,
						dataType : 'json',
						success : function(resoult) {
							if (resoult.userId != null) {
								fromUser = resoult;
							} else {
								layer.alert('查询错误');
							}
						},
						error : function(resoult) {
							layer.alert('查询错误');
						}
					});
					showTime = fromUser.userNickName + '&nbsp;&nbsp;'
							+ showTime;
				}

				leftArrow = '<div class="row singleMessage">'
						+ '<div id="icons" class="col-md-1 col-sm-1 col-xs-1 col-lg-1  iconsLeft">'
						+ '<img class="img-circle iconssLeft" src="img/photo.jpg">'
						+ '</div>'
						+ '<div class="col-md-11 col-sm-11 col-xs-11 col-lg-11 text">'
						+ '<div class="col-md-12 col-sm-12 col-xs-12 col-lg-12 timePositionLeft">'
						+ '<div class="timeLeft">' + showTime + '</div>'
						+ '</div>' + '<div class="arrowBoxLeft">'
						+ '<div id="leftMessage" class="message">' + content
						+ '</div>' + '</div>' + '</div>' + '</div>';
				if (target) {
					$(messageReceiver).append(leftArrow);
					target.scrollTop = target.scrollHeight;
				} else {
					alert("doMessageNotice  to======="+ to);
					doMessageNotice(content, from, to, type, time, message);
				}

			}
			
		}
		
		//发送群聊消息传递准备工作
		function sendGroupMessagePre(id) {
			var group = ajaxGetGroupById(id);
			var textAreaId = id + 'messageTextGroup';
			var message = document.getElementById(textAreaId).value;
			if(message != ''){
				var toUsersIdString = new Array();
				toUsersIdString = (group.groupMembers).split(',');
				var toUsersId = new Array();
				for(var i=0;i<toUsersIdString.length;i++){
					//toUsersId[i] = parseInt(toUsersIdString[i]);
						if (toUsersIdString[i] != "${currentUser.id}") {
					     alert("发送消息目标id"+toUsersIdString[i])
					     sendMessage(message, parseInt(toUsersIdString[i]) ,1);
						}
				}
				//sendMessage(message, toUsersId ,1);
				document.getElementById(textAreaId).value = '';
			}
		}
		
		
		
		
		
		
		
		//邀请新成员    加群邀请好友名单    这里呢 只有创建群的 人 才能邀请   如果  
		//要实现 其他人 也能 邀请时    数据库 的  userGroup 表 要 增加 一个 字段    userRoleGroup 即用户在群的角色   0  普通成员  1  管理员  2创建者
		function groupInvite(id) {
			var allRelations = getAllRelations();
			var html = '<div class="groupInviteList">'
					+ '<table class="table table-striped table-hover">'
					+ '<tr>' + '<th>#</th>' + '<th>用户名</th>' + '<th>昵称</th>'
					+ '<th>邀请</th>' + '</tr>';
			for (var i = 0; i < allRelations.length; i++) {
				html += '<tr>'
						+ '<td>'
						+ (i + 1)
						+ '</td>'
						+ '<td>'
						+ allRelations[i].name
						+ '</td>'
						+ '<td>'
						+ allRelations[i].userNickName
						+ '</td>'
						+ '<td>'
						+ '<button type="button" class="btn btn-default" onclick="groupInviteUser('
						+ id + ',' + allRelations[i].id + ')">邀请入群</button>'
				'</td>' + '</tr>';
			}
			html += '</table>' + '</div>';
			layer.open({
				type : 1,
				title : '邀请好友入群',
				content : html,
				area : [ '400px', '600px' ],
				resize : false,
				zIndex : layer.zIndex,
				success : function(layero) {
					layer.setTop(layero);
				}
			});
		}

		//邀请  好友入群
		// 这个id 是  群的id
		function groupInviteUser(id, userId) {
			var message = id;
			/* 	var toUsersId = new Array();
				toUsersId[0] = userId; */
			sendMessage(message, userId, 6);
		}

		//同意加群邀请
		function agreeGroupInvite(id) {
			var addGroup = {};
			addGroup.id = id;
			addGroup.userId = "${currentUser.id}";
			$.ajax({
				async : false, //设置同步
				type : 'POST',
				url : '${cp}/addGroupUsers',
				data : addGroup,
				dataType : 'json',
				success : function(resoult) {
					if (resoult.resoult == 'success') {

					} else {
						text = '是上天不允许我们建立联系啊！';
					}
				},
				error : function(resoult) {
					layer.msg('添加失败', {
						icon : 6,
						zIndex : 20000001,
						time : 2000
					});
				}
			});
			var addFriendRow = document.getElementById(id + 'addFriendRow');
			addFriendRow.style.display = 'none';
			relationApplyNumber--;
			if (relationApplyNumber == 0)
				layer.close(relationApply);
		}

		//拒绝加群邀请
		function refuseGroupInvite(id) {
			var addFriendRow = document.getElementById(id + 'addFriendRow');
			addFriendRow.style.display = 'none';
			relationApplyNumber--;
			if (relationApplyNumber == 0)
				layer.close(relationApply);
		}

		//列出群成员
		function groupUserList(id) {
			//请求
			var usersAndUserGroup = getGroupAllUsers(id);
			var users = usersAndUserGroup.users;
			var userGroup = usersAndUserGroup.userGroups;
			var html = '<div class="groupInviteList">'
					+ '<table class="table table-striped table-hover">'
					+ '<tr>' + '<th>#</th>' + '<th>用户名</th>' + '<th>昵称</th>'
					+ '<th>群昵称</th>' + '<th>等级</th>' + '<th>进群时间</th>'
					+ '</tr>';
			for (var i = 0; i < users.length; i++) {
				html += '<tr>' + '<td>' + (i + 1) + '</td>' + '<td>'
						+ users[i].name + '</td>' + '<td>'
						+ users[i].userNickName + '</td>' + '<td>'
						+ userGroup[i].groupUserNickName + '</td>' + '<td>'
						+ userGroup[i].groupLevel + '</td>' + '<td>'
						+ userGroup[i].enterGroupTime + '</td>' + '</tr>';
			}
			html += '</table>' + '</div>';
			layer.open({
				type : 1,
				title : '邀请好友入群',
				content : html,
				area : [ '500px', '600px' ],
				resize : false,
				zIndex : layer.zIndex,
				success : function(layero) {
					layer.setTop(layero);
				}
			});
		}
		//测试
		function test() {
			addFriend(1, '测试', '测试');
		}
	</script>
</body>
</html>