<%@ page language="java" pageEncoding="UTF-8"%>
<link rel="shortcut icon" href="${stccdn}/favicon.ico" />
<link rel="stylesheet" href="${stccdn}/css/common.css" />
<link rel="stylesheet" href="${stccdn}/css/components.css" />
<link rel="stylesheet" href="${stccdn}/css/custom.css" />
<link rel="stylesheet" href="${stccdn}/css/icon.css" />
<link rel="stylesheet" href="${stccdn}/plugin/font-awesome-4.6.3/css/font-awesome.min.css" />
<link rel="stylesheet" href="${stccdn}/plugin/miui-1.0/jquery.miui.css" />
<script src="${stccdn}/plugin/jquery-1.11.0/jquery.min.js"></script>
<script src="${stccdn}/plugin/layer-mobile-2.0/layer.js"></script>
<script src="${stccdn}/plugin/miui-1.0/jquery.miui.js"></script>
<script src="${stccdn}/plugin/fastclick-1.0/fastclick.js "></script>
<script src="${stccdn}/js/common.js"></script>
<script src="${stccdn}/js/util.js"></script>
<script>
  var Config = {
    stc : '${stc}',
    ctx : '${ctx}',
    stccdn : '${stccdn}'
  }
</script>
<c:if test='${not empty result}'>
<script>
  $(function() {
    switch ('${result.code}') {
      case '0':
        messageShow('${result.message}', 'success', 5);
        break;
      case '500':
        messageShow('${result.message}', 'error', 5);
        break;
      default:
        messageShow('${result.message}', 'info', 5);
        break;
    }
  });
</script>
</c:if>

