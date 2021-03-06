<%@ page language="java" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/view/include/taglib.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="Cache-Control" content="no-store"/>
<meta http-equiv="Pragma" content="no-cache"/>
<meta http-equiv="Expires" content="0"/>
<meta name="apple-mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-status-bar-style" content="black">
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

<title>积分钱包</title>
<%@ include file="/WEB-INF/view/include/head.jsp" %>
<link rel="stylesheet" href="${stccdn}/css/ucenter/account.css">
  <style>
    @charset "utf-8";
    html, body, div, p, ul, li, dl, dt, dd, h1, h2, h3, h4, h5, h6, form, input, select, button, textarea, iframe, table, th, td { margin: 0; padding: 0; }
    body { font-family:"Microsoft YaHei";background: #fff; font-size: 26px; color: #151515; margin: 0; padding: 0; }
    img { border: 0 none; vertical-align: top; display:inline-block; -ms-interpolation-mode: bicubic; image-rendering:optimizeQuality; }
    button { cursor: pointer; border:0 none; }
    input{ border:0 none; background:transparent; }
    textarea{ resize: none; border:0 none; }
    ul, li { list-style-type: none; }
    table{ border-collapse:collapse; border-spacing:0; }
    i, em, cite { font-style: normal; }
    p{word-wrap:break-word; }
    body, input, select, button,textarea{ outline: none; }
    a { display:block; }
    a,input,textarea,p,span,h2,em,li,div{text-decoration: none; }
    input,textarea{font-family:"Microsoft YaHei"}
    .clearfloat:before, .clearfloat:after {
      content:"";  display:table;
    }
    .clearfloat:after{
      clear:both;  overflow:hidden;
    }
    .clearfloat{
      zoom:1;
    }
     body{background: #eeeeee;}
    .bgSum {
      width:100%;
      background: #fff;
      background-size: cover;
      padding: 30px;
      padding-bottom: 0;
      padding-top: 20px;
      margin-bottom: 15px;
    }
    .bgSum p {
      width: 100%;
      font-size: 16px !important;
      margin-bottom:10px;
      color: #909192;
    }
    .bgSum p.percent {
      width: 45%;
      float: left;
      font-size: 16px !important;
      margin-bottom:10px;
      color: #909192;
    }
    .bgSum p.last {
      margin-left:10%;
    }
    .bgSum p span {
      float:right;
      color: #49494a;
      font-size: 16px !important;
    }
    .bgSum p span.percentNum {
      margin-right: 10px;
    }
    #echartFir {
      width:100%;
      height:280px;
      color: #49494a;
      background: #fff !important;
    }
    #last {background: #fff !important;}
    .all {
      width: 100%;
      height: 150px;
      position: relative;
      padding:10px 15px 0 15px;
    }
    .all img {
      width:100%;
      height:135px;
    }
    .percentNum {
      width:100%;
      height:135px;
      background: #fff;
      -webkit-border-radius:5px;
      -moz-border-radius:5px;
      border-radius:5px;
    }
    .percentNumDiv {
      width:100%;
      height:90px;
      border-bottom: 1px solid #ddd;
      padding-top: 10px;
    }
    .fontImg {
      width:100%;
      height:40px;
      line-height: 35px;
      color: #646565;
      font-size:17px;
    }
    .fontImg span {
      float: left;
      margin-left:10px;
    }
    .fontImg img {
      float: left;
      width:35px;
      height:35px;
      margin-left:10px;
    }
    .fontImg p{
      float: left;
      width:50%;
      font-size: 14px;
    }
    .fontImg p span {
      margin-left: 10px;
    }
    .fontImg p span.new {
      margin-left: 0;
    }
    .look {
      width:100%;
      color:#6cb92d;
      font-size: 16px;
      text-align: center;
      line-height: 45px;
    }
    .teamAllAccount {height: 50px;background: #fff;padding-top: 10px;}
    .teamAllAccount img {float: left;width: 40px;height: 40px;margin-left: 8px;margin-top: 5px;}
    .teamAllAccount span {
      float: left;line-height: 50px;margin-left: 0px;font-size: 18px;
      color: #838385;
    }
    .teamAllAccount a,.teamAllAccount span.paim {
      float: right;
      line-height: 50px;
      color: #6cb92d;
      margin-right: 15px;
    }

  </style>
  <script>
	  $(function() {
      $('.header .button-popmenu').click(function(){
        $('.header-popmenu').toggle(300);
      });
	  });
  </script>
</head>

<body class="account">
<header class="header">
  <a href="${ctx}/u" class="button-left"><i class="fa fa-angle-left"></i></a>
  <a href="javascript:;" class="button-right button-popmenu"><i class="fa fa-ellipsis-h"></i></a>
  <nav class="header-popmenu hide">
    <a id="btnCancel" href="${ctx}/u/bankCard" style="background-color: #3d7878;"><i class="icon icon-account-card"></i> 银行卡</a>
  </nav>
</header>
<article>
  <nav class="flex account-nav pb-30">
    <a class="flex-1 text-center" href="${ctx}/u/money?currencyType=0">
      <div class="mb-10"><i class="icon icon-account-umoney"></i></div>
      <div class="fs-16 lh-24">U币</div>
      <div class="fs-12 lh-20 font-ccc">${dataMap.amount1}</div>
    </a>
    <a class="flex-1 text-center" href="${ctx}/u/money?currencyType=1">
      <div class="mb-10"><i class="icon icon-account-money"></i></div>
      <div class="fs-16 lh-24">积分</div>
      <div class="fs-12 lh-20 font-ccc">${dataMap.amount2}</div>
    </a>
    <a class="flex-1 text-center" href="${ctx}/u/money?currencyType=2">
      <div class="mb-10"><i class="icon icon-account-option"></i></div>
      <div class="fs-16 lh-24">期权</div>
      <div class="fs-12 lh-20 font-ccc">${dataMap.amount3}</div>
    </a>
  </nav>
  <div class="bgSum clearfloat">
      <p>上月收入：<span>¥<fmt:formatNumber type="number" value="${dataMap.BM}" pattern="0.00" maxFractionDigits="2"/></span></p>
      <p>当前累计：<span>¥<fmt:formatNumber type="number" value="${dataMap.TOT}" pattern="0.00" maxFractionDigits="2"/></span></p>
      <p>上月环比：<span><fmt:formatNumber type="number" value="${dataMap.QoQ}" pattern="0.00" maxFractionDigits="2"/>%</span></p>
      <%--<p>上月同比：<span>¥<fmt:formatNumber type="number" value="${dataMap.YoY}" pattern="0.00" maxFractionDigits="2"/>%</span></p>--%>
  </div>
  <div class="allAccount" style="padding-bottom: 20px;">
    <div class="teamAllAccount">
      <img src="${ctx}/images/pvoluer.png"/>
      <span>个人销量</span>
    </div>
    <div id="echartFir"></div>
  </div>
  <div class="allAccount">
    <div class="teamAllAccount">
      <img src="${ctx}/images/leiji.png" />
      <span>累计收益占比</span>
    </div>
    <div id="last" style="width: 100%;height: 350px;padding: 10px;"></div>
  </div>
  <c:if test="${dataMap.ord[0] > 0 || dataMap.ord[1] > 0}">
      <div class="all">
        <div class="percentNum">
             <div class="percentNumDiv">
                   <div class="fontImg clearfloat">
                     <img src="${ctx}/images/01.png" />
                     <span>订单收益</span>
                   </div>
                 <div class="fontImg clearfloat">
                      <p><span>上月收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.ord[0]}" pattern="0.00" maxFractionDigits="2"/></p>
                      <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.ord[1]}" pattern="0.00" maxFractionDigits="2"/></p>
                 </div>
             </div>
          <a href="${ctx}/u/profit/orderRevenue?type=1" class="look">查看详情</a>
        </div>
      </div>
  </c:if>

    <c:if test="${dataMap.red[0] > 0 || dataMap.red[1] > 0}">
      <div class="all">
        <div class="percentNum">
          <div class="percentNumDiv">
            <div class="fontImg clearfloat">
              <img src="${ctx}/images/02.png" />
              <span>返利奖</span>
            </div>
            <div class="fontImg clearfloat">
              <p><span>上月收益：</span>￥</span>￥<fmt:formatNumber type="number" value="${dataMap.red[0]}" pattern="0.00" maxFractionDigits="2"/></p>
              <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.red[1]}" pattern="0.00" maxFractionDigits="2"/></p>
            </div>
          </div>
          <a href="${ctx}/u/profit/orderRevenue?type=7" class="look">查看详情</a>
        </div>
      </div>
    </c:if>

    <c:if test="${dataMap.dat[0] > 0 || dataMap.dat[1] > 0}">
      <div class="all">
        <div class="percentNum">
          <div class="percentNumDiv">
            <div class="fontImg clearfloat">
              <img src="${ctx}/images/03.png" />
              <span>历史收益</span>
            </div>
            <div class="fontImg clearfloat">
              <p><span>上月收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.dat[0]}" pattern="0.00" maxFractionDigits="2"/></p>
              <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.dat[1]}" pattern="0.00" maxFractionDigits="2"/></p>
            </div>
          </div>
          <a href="${ctx}/u/profit/orderRevenue?type=2" class="look">查看详情</a>
        </div>
      </div>
    </c:if>

  <c:if test="${dataMap.sal[0] > 0 || dataMap.sal[1] > 0}">
    <div class="all">
      <div class="percentNum">
        <div class="percentNumDiv">
          <div class="fontImg clearfloat">
            <img src="${ctx}/images/04.png" />
            <span >销量奖</span>
          </div>
          <div class="fontImg clearfloat">
            <p><span>上月收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.sal[0]}" pattern="0.00" maxFractionDigits="2"/></p>
            <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.sal[1]}" pattern="0.00" maxFractionDigits="2"/></p>
          </div>
        </div>
        <a href="${ctx}/u/profit/orderRevenue?type=3" class="look">查看详情</a>
      </div>
    </div>
  </c:if>

  <c:if test="${dataMap.ftl[0] > 0 || dataMap.ftl[1] > 0}">
    <div class="all">
      <div class="percentNum">
        <div class="percentNumDiv">
          <div class="fontImg clearfloat">
            <img src="${ctx}/images/05.png" />
            <span>特级平级奖</span>
          </div>
          <div class="fontImg clearfloat">
            <p><span>上月收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.ftl[0]}" pattern="0.00" maxFractionDigits="2"/></p>
            <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.ftl[1]}" pattern="0.00" maxFractionDigits="2"/></p>
          </div>
        </div>
        <a href="${ctx}/u/profit/orderRevenue?type=4" class="look">查看详情</a>
      </div>
    </div>
  </c:if>

  <c:if test="${dataMap.sen[0] > 0 || dataMap.sen[1] > 0}">
    <div class="all">
      <div class="percentNum">
        <div class="percentNumDiv">
          <div class="fontImg clearfloat">
            <img src="${ctx}/images/06.png" />
            <span>董事贡献奖</span>
          </div>
          <div class="fontImg clearfloat">
            <p><span>上月收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.sen[0]}" pattern="0.00" maxFractionDigits="2"/></p>
            <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.sen[1]}" pattern="0.00" maxFractionDigits="2"/></p>
          </div>
        </div>
        <a href="${ctx}/u/profit/orderRevenue?type=8" class="look">查看详情</a>
      </div>
    </div>
  </c:if>

  <c:if test="${dataMap.ltl[0] > 0 || dataMap.ltl[1] > 0}">
    <div class="all">
      <div class="percentNum">
        <div class="percentNumDiv">
          <div class="fontImg clearfloat">
            <img src="${ctx}/images/07.png" />
            <span>平级推荐奖</span>
          </div>
          <div class="fontImg clearfloat">
            <p><span>上月收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.ltl[0]}" pattern="0.00" maxFractionDigits="2"/></p>
            <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.ltl[1]}" pattern="0.00" maxFractionDigits="2"/></p>
          </div>
        </div>
        <a href="${ctx}/u/profit/orderRevenue?type=5" class="look">查看详情</a>
      </div>
    </div>
  </c:if>

  <c:if test="${dataMap.rec[0] > 0 || dataMap.rec[1] > 0}">
    <div class="all">
      <div class="percentNum">
        <div class="percentNumDiv">
          <div class="fontImg clearfloat">
            <img src="${ctx}/images/08.png" />
            <span>特级推荐奖</span>
          </div>
          <div class="fontImg clearfloat">
            <p><span>上月收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.rec[0]}" pattern="0.00" maxFractionDigits="2"/></p>
            <p><span class="new">累计收益：</span>￥<fmt:formatNumber type="number" value="${dataMap.rec[1]}" pattern="0.00" maxFractionDigits="2"/></p>
          </div>
        </div>
        <a href="${ctx}/u/profit/orderRevenue?type=6" class="look">查看详情</a>
      </div>
    </div>
  </c:if>
</article>
<script src="${ctx}/js/echarts.min.js"></script>
<script type="text/javascript">
  var arrays="${dataMap.PL}";
  var array=arrays.split(",");
//  var arrayNew=[];
//  var arrayNewT=[];
//  for(var i=0;i<array.length;i++){
//    if(i%2==0){
//      arrayNew.push(array[i]);
//      arrayNewT.push('-');
//    }else {
//      arrayNew.push('-');
//      arrayNewT.push(array[i]);
//    }
//  }
  var symbolSize = 20;
  // 基于准备好的dom，初始化echarts实例
  var myChart = echarts.init(document.getElementById('echartFir'));
  // 指定图表的配置项和数据
  option = {
    tooltip: {
      trigger: 'axis'
    },
    grid: {
      left: '3%',
      right: '4%',
      top: '15%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      axisLine: {
        onZero: false,
        lineStyle: {
          color: "#68dcc1"
        }
      },
      data : ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
    },
    yAxis: {
      type: 'value',
      axisLabel: {
        formatter: '{value}'
      },
      axisLine: {
        onZero: false,
        lineStyle: {
          color: "#68dcc1"
        }
      },
    },
    series: [
      {
        name: '金额',
        type: 'line',
        stack: '总量',
        areaStyle: {normal: {}},

        label: {
          normal: {
            show: true,
            position: 'top'
          }
        },
        itemStyle: {
          normal: {
            color:'#68dcc1'
          }
        },
        data: array
      }
    ]
  };
  // 使用刚指定的配置项和数据显示图表。
  myChart.setOption(option);
</script>

<script>
  var piedata ="${dataMap.pie}";
  var array=piedata.split(",");
  var myChartSec = echarts.init(document.getElementById('last'));
  optionSec = {
    tooltip : {
      trigger: 'item',
      formatter: "{a} <br/>{b} : {c} ({d}%)"
    },
//    toolbox: {
//      show : true,
//      feature : {
//        mark : {show: false},
//        dataView : {show: true, readOnly: false},
//        magicType : {
//          show: true,
//          type: ['pie', 'funnel']
//        },
//        saveAsImage : {show: true}
//      }
//    },
    calculable : true,
    series : [
      {
        name:'累计收益',
        type:'pie',
        radius : [30, 110],
        center : ['50%', '50%'],
        roseType : 'area',
        color:['#62f89e','#86dcd4','#5bd0c4','#68dcc1','#6cbbe3','#88c3db','#5c97e8','#31d9a5'],
        data:[
          {value:array[0], name:'特级平级奖'},
          {value:array[1], name:'订单收益'},
          {value:array[2], name:'返利奖'},
          {value:array[3], name:'历史收益'},
          {value:array[4], name:'董事贡献奖'},
          {value:array[5], name:'特级推荐奖'},
          {value:array[6], name:'平级推荐奖'},
          {value:array[7], name:'销量奖'}
        ]
      }
    ]
  };
  myChartSec.setOption(optionSec);

</script>

</body>

</html>
