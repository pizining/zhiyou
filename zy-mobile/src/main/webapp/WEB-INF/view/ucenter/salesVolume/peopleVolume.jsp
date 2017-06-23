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

  <title>销量</title>
  <%@ include file="/WEB-INF/view/include/head.jsp"%>
  <style>
    body {background: #eeeeee}
    .all {
      background: #fff !important;
      margin-top: 10px;
    }
    #echartTeamTwo,#echartTeamFor {
      width:100%;
      height:200px;
      background: #fff !important;
    }
    #echartTeamFor {
      height:250px;
    }
    .teamAll {height: 50px;}
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
      height: 40px;
      margin-top: 10px;
      margin-bottom: 10px;
      margin-left: 15px;
      -webkit-border-radius:50%;
      -moz-border-radius:50%;
      border-radius:50%;
    }
  </style>
</head>
<body>
<header class="header">
  <h1>${userName}的销量</h1>
  <a href="#" onclick="javascript :history.back(-1);" class="button-left"><i class="fa fa-angle-left"></i></a>
</header>

<article>

  <div class="all" style="padding-bottom: 20px;">
    <div class="teamAll">
      <img src="${ctx}/teamNew.png"/>
      <span>${userName}的销量</span>
    </div>
    <div id="echartTeamTwo"></div>
    <div id="echartTeamFor" style="margin-top: 20px;"></div>
  </div>

</article>
<script src="${ctx}/echarts.min.js"></script>
<script type="text/javascript">
  var svArray = "${dateMap.salesVolumeData}";
  var array = svArray.split(",");

  var sArray = "${dateMap.shipmentData}";
  var arrayT = sArray.split(",");
  var mbolSize = 20;
  // 基于准备好的dom，初始化echarts实例
  var myChart = echarts.init(document.getElementById('echartTeamTwo'));
  // 指定图表的配置项和数据
  optionTwo = {
    tooltip : {
      trigger: 'axis',
      axisPointer : {            // 坐标轴指示器，坐标轴触发有效
        type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
      }
    },
    legend: {
      data:['进货量','销货量']
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis : [
      {
        type : 'category',
        data : ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
      }
    ],
    yAxis : [
      {
        type : 'value'
      }
    ],
    series : [
      {
        name:'进货量',
        type:'bar',
        stack: '广告',
        itemStyle: {
          normal: {
            color:'#6cb92d'
          }
        },
        data:array
      },

      {
        name:'销货量',
        type:'bar',
        itemStyle: {
          normal: {
            color:'#add889'
          }
        },
        data:arrayT
      }
    ]
  };
  // 使用刚指定的配置项和数据显示图表。
  myChart.setOption(optionTwo);
</script>

<script type="text/javascript">
  var svArray = "${dateMap.svData}";
  var array = svArray.split(",");

  var sArray = "${dateMap.sData}";
  var arrayT = sArray.split(",");
  var mbolSize = 40;
  // 基于准备好的dom，初始化echarts实例
  var myChart = echarts.init(document.getElementById('echartTeamFor'));
  // 指定图表的配置项和数据
  optionFor = {
    tooltip: {
      trigger: 'axis'
    },
    legend: {
      data:['进货量环比','销货量环比']
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },

    xAxis: {
      type: 'category',
      boundaryGap: false,
      data : ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']
    },
    yAxis: {
      type: 'value'
    },
    series: [
      {
        name:'进货量环比',
        type:'line',
        stack: '总量',
        itemStyle: {
          normal: {
            color:'#6cb92d'
          }
        },
        data:array
      },
      {
        name:'销货量环比',
        type:'line',
        stack: '总量',
//        label: {
//          normal: {
//            show: true,
//            position: 'top'
//          }
//        },
        itemStyle: {
          normal: {
            color:'#fc4e33'
          }
        },
        data:arrayT
      }
    ]
  };
  // 使用刚指定的配置项和数据显示图表。
  myChart.setOption(optionFor);
</script>

<%@ include file="/WEB-INF/view/include/footer.jsp"%>
</body>
</html>
