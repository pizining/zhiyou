<%@ page language="java" pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ include file="/WEB-INF/view/include/taglib.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text; charset=utf-8">
    <meta http-equiv="Cache-Control" content="no-store" />
    <meta http-equiv="Pragma" content="no-cache" />
    <meta http-equiv="Expires" content="0" />
    <meta name="apple-mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-status-bar-style" content="black">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

    <title>直属团队详情</title>
    <%@ include file="/WEB-INF/view/include/head.jsp"%>
    <script src="${stccdn}/plugin/laytpl-1.1/laytpl.js"></script>
    <style>
        body {background: #f7f7f9}
        /*清除浮动代码*/
        .clearfloat:before, .clearfloat:after {
            content:"";
            display:table;
        }
        .clearfloat:after{
            clear:both;
            overflow:hidden;
        }
        .clearfloat{
            zoom:1;
        }
        body,html {font-family:  "Microsoft YaHei";text-overflow: ellipsis;
            white-space: nowrap;}
        a {display: block;}
        .all {
            width: 100%;
            background: #fff !important;
            border-bottom: 1px solid #e5e5e5;
        }
        .teamAll img {float: left;width: 50px;height: 50px;margin-left: 8px;}
        .teamAll span {
            float: left;line-height: 50px;margin-left: 20px;font-size: 18px;
            color: #838385;
        }
        .teamAll a,.teamAll span.paim {
            float: right;
            line-height: 50px;
            color: #6cb92d;
            margin-right: 15px;
        }
        .TeamName img {
            width:55%;
            margin-top:20px;
        }
        .TeamName span {
            display: block;
            margin-top:10px;
        }
        .rankingAllList {border-bottom: 1px solid #e5e5e5;}
        .rankingAll {
            width:100%;
            height:60px;
        }
        .rankingAll>span {
            float: left;
            display: block;;
            width:65px;
            height:100%;
            text-align: center;
            line-height:60px;
        }
        .rankingAll>img {
            float: left;
            width: 40px;
            margin-top: 10px;
            margin-bottom: 10px;
            height:40px;
            -webkit-border-radius:50%;
            -moz-border-radius:50%;
            border-radius:50%;
        }
        .ranking {
            float: left;
            width:200px;
            height:100%;
            text-align: center;
            line-height: 60px;
        }
        .rankingSpan {
            padding:0 8px 0 8px;
            color: #fff;
            font-size: 12px;
        }

        .teamTop {
            width:90%;
            height:60px;
            margin-left: 5%;
            position: relative;
        }
        .teamTop img {
            position: absolute;
            width:70%;
            height:30px;
            top: 15px;
            z-index: 1;
        }
        .teamTop input {
            position: absolute;
            background: none;
            width:70%;
            height:30px;
            border: none;
            top: 15px;
            z-index: 2;
        }
        .teamTop img.seatchImg,.searchBtn {
            width:20%;
            height:30px;
            color: #6cb92d;
            text-align: center;
            line-height: 30px;
            position: absolute;
            left:80%;
            top:15px;
            z-index: 1;
        }
        .searchBtn {
            background: none;
            border:none;
            z-index: 2;
        }
        .rankingTop {font-size: 18px}
        .rankingAll>span.tel {
            width:60px;
            float: right;
            margin-right: 20px;
            color: #303134;
        }
        .sanjiao {
            float: left;
            height:60px;
            width:50px;
            position: relative;
        }
        .jiaoOne {
            width: 0;
            height: 0;
            border-top:8px solid transparent;
            border-bottom: 8px solid transparent;
            border-left: 8px solid #b4b4b4;
            position: absolute;
            left: 50%;
            top:50%;
            margin-left: -4px;
            margin-top: -8px;
        }
        .jiaoTwo {
            width: 0;
            height: 0;
            border-left:8px solid transparent;
            border-right:8px solid transparent;
            border-top:8px solid #b4b4b4;
            border-bottom: 0px solid transparent;
            position: absolute;
            left: 50%;
            top:50%;
            margin-left: -8px;
            margin-top: -4px;
        }
        /*联合创始人*/
        .must {
            background: #ffcd48;
        }
        .province {
            background: #7ed1df;
        }
        .city {
            background: #ffb558;
        }
        .VIP {
            background: #51c187;
        }
        .com {
            background: #91c7ae;
        }
        .telAll {
            float: right;
            margin-right: 20px;
            height:60px;
        }
        .telAll img {
            width:20px;
            margin-top: 20px;
        }
        .jian {margin-right: 0;padding-right: 20px;}
        .jian img {
            margin-top: 24px;
        }
        .allLast {display: none;}
        .searchList {
            width:100%;
            height: 80px;
            background: #fff;
            text-align: center;
            line-height:80px;
            font-size: 20px;
            display: none;
        }
        .searchListShow {
            background: #fff;
            display: none;
        }
        .teamListNum {
            width:100%;
            height:40px;
            background: #fff;
        }
        .rankingNum {
            width:100%;
            height:60px;
            display: none;
        }
        .rankingAllList:last-child {
            border-bottom: none;
        }
        .ranknumber {
            float: left;
            width:25%;
        }
        .ranknumber p {
            width:100%;
            text-align: center;
            line-height: 25px;
            color: #a6a6a6;
        }
        @media (device-height:568px) and (-webkit-min-device-pixel-ratio:2){/* 兼容iphone5 */
            .ranking {
                width:150px;
            }
        }
    </style>
</head>
<body>
<header class="header">
    <h1>直属团队详情</h1>
    <a href="${ctx}/u/team/newTeam?productType=${productType}" class="button-left"><i class="fa fa-angle-left"></i></a>
</header>

<article>
    <div class="teamTop">
        <img src="${ctx}/images/seatch.png" />
        <input type="search" class="searchInput" placeholder="请输入姓名或手机号" />
        <img src="${ctx}/images/searchBtn.png" class="seatchImg" onclick="seatch()" />
        <div class="searchBtn" onclick="seatch()">搜索</div>
    </div>
    <div class="numberList">
        <div class="all" change="false" onclick="showList(this)">
            <div class="rankingAll">
                <div class="ranking">
                    <div class="sanjiao">
                        <div class="jiaoOne"></div>
                    </div>
                    <span class="rankingTop">联合创始人</span>
                    <span class="rankingSpan must">联合创始人</span>
                </div>
                <span class="tel">${fn:length(v4)}人</span>
            </div>
        </div>
        <div class="all allLast">
            <c:forEach items="${v4}" var="v4user" varStatus="indexs">
                <div class="rankingAllList">
                    <div class="rankingAll">
                        <img src="${v4user.avatar}" style="margin-left: 20px;margin-right: 20px;"/>
                        <div class="ranking" style="text-align: left;font-size: 18px;">
                            <span>${v4user.nickname}</span>
                         <%--   <img src="${ctx}/new.png"style="width: 30px;"/>--%>
                        </div>
                        <div class="telAll jian" onclick="showNum(this,${v4user.id},'V4',${indexs.index})" change="true">
                            <img src="${ctx}/images/jian.png" />
                        </div>
                        <a href="tel:${v4user.phone}" class="telAll">
                            <img src="${ctx}/images/tel.png" />
                        </a>
                    </div>
                    <div class="rankingNum">
                        <div class="ranknumber">
                            <p id="V4must${indexs.index}"></p>
                            <p>联合创始人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V4pro${indexs.index}"></p>
                            <p>品牌合伙人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V4city${indexs.index}"></p>
                            <p>品牌经理</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V4vip${indexs.index}"></p>
                            <p>VIP</p>
                        </div>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V4com${indexs.index}"></p>--%>
                            <%--<p>普通用户</p>--%>
                        <%--</div>--%>
                    </div>
                </div>
            </c:forEach>

        </div>

        <div class="all" change="false" onclick="showList(this)">
            <div class="rankingAll">
                <div class="ranking">
                    <div class="sanjiao">
                        <div class="jiaoOne"></div>
                    </div>
                    <span class="rankingTop">品牌合伙人</span>
                    <span class="rankingSpan province">品牌合伙人</span>
                </div>
                <span class="tel">${fn:length(v3)}人</span>
            </div>
        </div>
        <div class="all allLast">
            <c:forEach items="${v3}" var="v3user" varStatus="indexs">
                <div class="rankingAllList">
                    <div class="rankingAll">
                        <img src="${v3user.avatar}" style="margin-left: 20px;margin-right: 20px;"/>
                        <div class="ranking" style="text-align: left;font-size: 18px;">
                            <span>${v3user.nickname}</span>
                                <%--   <img src="${ctx}/new.png"style="width: 30px;"/>--%>
                        </div>
                        <div class="telAll jian" onclick="showNum(this,${v3user.id},'V3',${indexs.index})" change="true">
                            <img src="${ctx}/images/jian.png" />
                        </div>
                        <a href="tel:${v3user.phone}" class="telAll">
                            <img src="${ctx}/images/tel.png" />
                        </a>
                    </div>
                    <div class="rankingNum">
                        <div class="ranknumber">
                            <p id="V3must${indexs.index}"></p>
                            <p>联合创始人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V3pro${indexs.index}"></p>
                            <p>品牌合伙人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V3city${indexs.index}"></p>
                            <p>品牌经理</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V3vip${indexs.index}"></p>
                            <p>VIP</p>
                        </div>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V3com${indexs.index}"></p>--%>
                            <%--<p>普通用户</p>--%>
                        <%--</div>--%>
                    </div>
                </div>
            </c:forEach>


        </div>
        <div class="all" change="false" onclick="showList(this)">
            <div class="rankingAll">
                <div class="ranking">
                    <div class="sanjiao">
                        <div class="jiaoOne"></div>
                    </div>
                    <span class="rankingTop">品牌经理</span>
                    <span class="rankingSpan city">品牌经理</span>
                </div>
                <span class="tel">${fn:length(v2)}人</span>
            </div>
        </div>

        <div class="all allLast">
            <c:forEach items="${v2}" var="v2user" varStatus="indexs">
                <div class="rankingAllList">
                    <div class="rankingAll">
                        <img src="${v2user.avatar}" style="margin-left: 20px;margin-right: 20px;"/>
                        <div class="ranking" style="text-align: left;font-size: 18px;">
                            <span>${v2user.nickname}</span>
                                <%--   <img src="${ctx}/new.png"style="width: 30px;"/>--%>
                        </div>
                        <div class="telAll jian" onclick="showNum(this,${v2user.id},'V2',${indexs.index})" change="true">
                            <img src="${ctx}/images/jian.png" />
                        </div>
                        <a href="tel:${v2user.phone}" class="telAll">
                            <img src="${ctx}/images/tel.png" />
                        </a>
                    </div>
                    <div class="rankingNum">
                        <div class="ranknumber">
                            <p id="V2must${indexs.index}"></p>
                            <p>联合创始人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V2pro${indexs.index}"></p>
                            <p>品牌合伙人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V2city${indexs.index}"></p>
                            <p>品牌经理</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V2vip${indexs.index}"></p>
                            <p>VIP</p>
                        </div>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V2com${indexs.index}"></p>--%>
                            <%--<p>普通用户</p>--%>
                        <%--</div>--%>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="all" change="false" onclick="showList(this)">
            <div class="rankingAll">
                <div class="ranking">
                    <div class="sanjiao">
                        <div class="jiaoOne"></div>
                    </div>
                    <span class="rankingTop">VIP</span>
                    <span class="rankingSpan VIP">VIP</span>
                </div>
                <span class="tel">${fn:length(v1)}人</span>
            </div>
        </div>
        <div class="all allLast">
            <c:forEach items="${v1}" var="v1user" varStatus="indexs">
                <div class="rankingAllList">
                    <div class="rankingAll">
                        <img src="${v1user.avatar}" style="margin-left: 20px;margin-right: 20px;"/>
                        <div class="ranking" style="text-align: left;font-size: 18px;">
                            <span>${v1user.nickname}</span>
                                <%--   <img src="${ctx}/new.png"style="width: 30px;"/>--%>
                        </div>
                        <div class="telAll jian" onclick="showNum(this,${v1user.id},'V1',${indexs.index})" change="true">
                            <img src="${ctx}/images/jian.png" />
                        </div>
                        <a href="tel:${v1user.phone}" class="telAll">
                            <img src="${ctx}/images/tel.png" />
                        </a>
                    </div>
                    <div class="rankingNum">
                        <div class="ranknumber">
                            <p id="V1must${indexs.index}"></p>
                            <p>联合创始人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V1pro${indexs.index}"></p>
                            <p>品牌合伙人</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V1city${indexs.index}"></p>
                            <p>品牌经理</p>
                        </div>
                        <div class="ranknumber">
                            <p id="V1vip${indexs.index}"></p>
                            <p>VIP</p>
                        </div>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V1com${indexs.index}"></p>--%>
                            <%--<p>普通用户</p>--%>
                        <%--</div>--%>
                    </div>
                </div>
            </c:forEach>
        </div>

        <%--<div class="all" change="false" onclick="showList(this)">--%>
            <%--<div class="rankingAll">--%>
                <%--<div class="ranking">--%>
                    <%--<div class="sanjiao">--%>
                        <%--<div class="jiaoOne"></div>--%>
                    <%--</div>--%>
                    <%--<span class="rankingTop">普通用户</span>--%>
                    <%--<span class="rankingSpan com">普通</span>--%>
                <%--</div>--%>
                <%--<span class="tel">${fn:length(v0)}人</span>--%>
            <%--</div>--%>
        <%--</div>--%>
        <%--<div class="all allLast">--%>
            <%--<c:forEach items="${v0}" var="v0user" varStatus="indexs">--%>
                <%--<div class="rankingAllList">--%>
                    <%--<div class="rankingAll">--%>
                        <%--<img src="${v0user.avatar}" style="margin-left: 20px;margin-right: 20px;"/>--%>
                        <%--<div class="ranking" style="text-align: left;font-size: 18px;">--%>
                            <%--<span>${v0user.nickname}</span>--%>
                                <%--&lt;%&ndash;   <img src="${ctx}/new.png"style="width: 30px;"/>&ndash;%&gt;--%>
                        <%--</div>--%>
                        <%--<div class="telAll jian" onclick="showNum(this,${v0user.id},'V0',${indexs.index})" change="true">--%>
                            <%--<img src="${ctx}/jian.png" />--%>
                        <%--</div>--%>
                        <%--<a href="tel:${v0user.phone}" class="telAll">--%>
                            <%--<img src="${ctx}/tel.png" />--%>
                        <%--</a>--%>
                    <%--</div>--%>
                    <%--<div class="rankingNum">--%>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V0must${indexs.index}"></p>--%>
                            <%--<p>联合创始人</p>--%>
                        <%--</div>--%>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V0pro${indexs.index}"></p>--%>
                            <%--<p>品牌合伙人</p>--%>
                        <%--</div>--%>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V0city${indexs.index}"></p>--%>
                            <%--<p>品牌经理</p>--%>
                        <%--</div>--%>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V0vip${indexs.index}"></p>--%>
                            <%--<p>VIP</p>--%>
                        <%--</div>--%>
                        <%--<div class="ranknumber">--%>
                            <%--<p id="V0com${indexs.index}"></p>--%>
                            <%--<p>普通用户</p>--%>
                        <%--</div>--%>
                    <%--</div>--%>
                <%--</div>--%>
            <%--</c:forEach>--%>
        <%--</div>--%>
    </div>

    <div class="searchList">查无此人!</div>
    <div class="searchListShow">

    </div>

    </div>
</article>
<script>
    //点击联合创始人品牌合伙人列表
    function showList(obj){
        if($(obj).attr("change")=="false"){
            $(obj).next(".allLast").show();
            $(obj).attr("change","true");
            $(obj).find(".jiaoOne").addClass("jiaoTwo");
        }else {
            $(obj).find(".jiaoOne").removeClass("jiaoTwo");
            $(obj).attr("change","false");
            $(obj).next(".allLast").hide();
        }
    }
    //点击下拉箭头
    function showNum(obj,id,type,index){
        $.ajax({
            url : '${ctx}/u/team/findDirectlyNum?productType=${productType}',
            data : {
                userId : id
            },
            dataType : 'json',
            type : 'POST',
            success : function(result) {
                if(result.code != 0) {
                    return;
                }
                var arrys = result.message;
                var arry =arrys.split(",");
                $("#"+type+"must"+index).text(arry[0]+"人");
                $("#"+type+"pro"+index).text(arry[1]+"人");
                $("#"+type+"city"+index).text(arry[2]+"人");
                $("#"+type+"vip"+index).text(arry[3]+"人");
                $("#"+type+"com"+index).text(arry[4]+"人");
                if($(obj).attr("change")=="true"){
                    $(obj).parents(".rankingAll").next(".rankingNum").show();
                    $(obj).find("img").attr("src","${ctx}/images/jian2.png");
                    $(obj).attr("change","false");
                }else {
                    $(obj).parents(".rankingAll").next(".rankingNum").hide();
                    $(obj).find("img").attr("src","${ctx}/images/jian.png");
                    $(obj).attr("change","true");
                }

            }
        });
    }

    //点击搜索
    function seatch() {
        $(".searchList").hide();
        $(".searchListShow").html("");
        if($(".searchInput").val()==""){
            $(".numberList").show();
            $(".searchListShow").hide();
        }else {
            $(".numberList").hide();
            $(".searchListShow").show();
            var phoneOrmame = $(".searchInput").val();

            $.ajax({
                url : '${ctx}/u/team/ajaxTeamDetail?productType=${productType}',
                data : {
                    nameorPhone:phoneOrmame
                },
                dataType : 'json',
                type : 'POST',
                success : function(result) {
                    if(result.code != 0) {
                        return;
                    }
                    var page = result.data.page;
                    if (page.data.length) {
                        var pageData = page.data;
                        for ( var i in pageData) {
                            var row = pageData[i];
                            if (row.userRank!="V0"){
                             buildRow(row);
                            }
                        }
                    }
                    if (!page.data.length || page.data.length < 0) {
                        $(".searchList").show();
                    }
                }
            });
        }

    }
    function buildRow(row,indexs){
        var rowTpl = document.getElementById('rowTpl').innerHTML;
        laytpl(rowTpl).render(row,function(html) {
            $('.searchListShow').append(html);
            $(".searchList").hide();
        });
    }
</script>
<script id="rowTpl" type="text/html">
    <div class="rankingAllList">
        <div class="rankingAll">
            <img src="{{d.avatar}}" style="margin-left: 20px;margin-right: 20px;"/>
             <div class="ranking" style="text-align: left;font-size: 18px;">
                 <span>{{ d.nickname }}</span>
                 <span class="rankingSpan {{ d.userRank =='V4'?'must':d.userRank =='V3'?'province':d.userRank =='V2'?'city':d.userRank =='V1'?'VIP':d.userRank=='V0'?'com':''}}">{{d.userRank =='V4'?'联合创始人':d.userRank =='V3'?'品牌合伙人':d.userRank =='V2'?'品牌经理':d.userRank =='V1'?'VIP':d.userRank =='V0'?'普通':''}}</span>
                <%-- <img src="${ctx}/new.png"style="width: 30px;"/>--%>
             </div>
            <div class="telAll jian" onclick="showNum(this,'{{ d.id }}','qv','{{ d.id }}')" change="true">
                <img src="${ctx}/images/jian.png" />
            </div>
            <a href="tel:{{ d.phone }}" class="telAll">
              <img src="${ctx}/images/tel.png" /></a>
        </div>
        <div class="rankingNum">
            <div class="ranknumber">
                <p id="qvmust{{d.id}}"></p>
                <p>联合创始人</p>
            </div>
            <div class="ranknumber">
                <p id="qvpro{{d.id}}"></p>
                <p>品牌合伙人</p>
            </div>
            <div class="ranknumber">
                <p id="qvcity{{d.id}}"></p>
                <p>品牌经理</p>
            </div>
            <div class="ranknumber">
                <p id="qvvip{{d.id}}"></p>
                <p>VIP</p>
            </div>
            <%--<div class="ranknumber">--%>
                <%--<p id="qvcom{{d.id}}"></p>--%>
                <%--<p>普通用户</p>--%>
            <%--</div>--%>
        </div>
    </div>
</script>
<%@ include file="/WEB-INF/view/include/footer.jsp"%>
</body>
</html>
