<%@ page import="java.net.URLEncoder" %>
// 预算信息截取
<script type="text/javascript">
    // 触发字段
    var zd1 = 'field7440';
    // 被赋值字段
    var zd2 = 'field7444';
    // 费用日期
    var fyrq = 'field7439';
    // 承担主体
    var cszt = 'field7497';
    // 科目
    var km = 'field7445';

    // 科目
    var budgetfeetype = '';
    // 承担主体类型（那个选择框的值）
    var orgType = '';
    // 承担主体
    var orgId = '';
    // 费用日期
    var applydate = '';
    // 明细id
    var dtl_id = '-987654321';
    // 当前流程id
    var temprequestid = '-1';

    jQuery(document).ready(function () {
        WfForm.bindFieldChangeEvent(zd1, function (obj, id, value) {
            applydate = WfForm.getFieldValue(fyrq);
            orgType = WfForm.getFieldValue(cszt);
            budgetfeetype = WfForm.getFieldValue(km);
            $.ajax({
                type: "post",
                url: "/workflow/request/tuanChe/ReciveBack.jsp",
                cache: false,
                async: false,
                data: {"value": value},
                success: function (data) {
                    data = data.replace(/\s+/g, "");
                    // data: 447,齐齐哈尔-201906-团车节
                    var datas = data.split(',');
                    orgId = datas[0];
                    WfForm.changeFieldValue(zd2, {
                        specialobj: [
                            {id: datas[0], name: datas[1]}
                        ]
                    });
                    var str = "budgetfeetype=" + budgetfeetype + "&orgtype=" + orgType + "&orgid=" + orgId + "&applydate=" + applydate + "&dtl_id=" + dtl_id + "&requestid=" + temprequestid;

//调用系统函数
                    jQuery.ajax({
                        url: "/workflow/request/FnaBudgetInfoAjax.jsp",
                        type: "post",
                        processData: false,
                        data: "budgetfeetype=" + budgetfeetype + "&orgtype=" + orgType + "&orgid=" + orgId + "&applydate=" + applydate + "&dtl_id=" + dtl_id + "&requestid=" + temprequestid,
                        dataType: "html",
                        success: function do4Success(msg) {

                            getFnaInfoData_callBack(jQuery.trim(msg), "");
                        }
                    });

                }
            });

        });
    });


</script>


<script type='text/javascript' src='https://tb.relxtech.com/javascripts/api/viz_v1.js'></script>
<div class='tableauPlaceholder' style='width: 1440px; height: 850px;'>
    <object class='tableauViz' width='1440' height='850' style='display:none;'>
        <param name='host_url' value='https%3A%2F%2Ftb.relxtech.com%2F'/>
        <param name='embed_code_version' value='3'/>
        <param name='site_root' value=''/>
        <param name='name' value='11&#47;sheet0'/>
        <param name='tabs' value='yes'/>
        <param name='toolbar' value='yes'/>
        <param name='showAppBanner' value='false'/>
        <param name='filter' value='iframeSizedToWindow=true'/>
    </object>
</div>

<%
    URLEncoder.encode("123");
%>