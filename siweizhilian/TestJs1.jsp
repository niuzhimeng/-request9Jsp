
// 项目经理新建项目组
<script type="text/javascript">
    // 日期
    var rq2 = '9552';

    jQuery(document).ready(function () {
        firstAdd('detail_4', rq2);
        setTimeout("sysFun()", 500);
    });

    function sysFun() {
        // 绑定新增明细事件
        _customAddFun3 = function (addIndexStr) {
            newAdd('detail_4', rq2, addIndexStr);
        };

        // 绑定删除事件
        _customDelFun3 = function () {
            setTimeout("deleteRow(rq2, 'detail_4')", 1000);
        };
    }

    /**
     * 删除某行时，日期重新递增赋值
     */
    function deleteRow(zdName, detailName) {
        var mxh = WfForm.getDetailAllRowIndexStr(detailName).split(',');
        var date = getCurrDate();
        //得到开始年
        var sYear = date.getFullYear();
        var len = mxh.length;
        for (var j = 0; j < len; j++) {
            var addDate = (sYear + j);
            WfForm.changeFieldValue("field" + zdName + "_" + mxh[j], {
                value: addDate,
                specialobj: [{id: addDate.toString(), name: addDate.toString()}]
            });
        }
    }

    /**
     * 新增行日期递增
     */
    function newAdd(detailName, zdName, addIndexStr) {
        var mxh = WfForm.getDetailAllRowIndexStr(detailName).split(',');
        var lastValue = WfForm.getFieldValue("field" + zdName + "_" + mxh[mxh.length - 2]);
        if (lastValue == null || lastValue == '' || lastValue == undefined) {
            var date = getCurrDate();
            //得到开始年
            var sYear = date.getFullYear() + 0;
            WfForm.changeFieldValue("field" + zdName + "_" + addIndexStr, {
                value: sYear,
                specialobj: [{id: sYear.toString(), name: sYear.toString()}]
            });
        } else {
            var newVar = Number(lastValue) + 1;
            WfForm.changeFieldValue("field" + zdName + "_" + addIndexStr, {
                value: newVar,
                specialobj: [{id: newVar.toString(), name: newVar.toString()}]
            });
        }
    }

    /**
     * 初始化插入五行明细
     */
    function firstAdd(detailName, zdName) {
        var mxh = WfForm.getDetailAllRowIndexStr(detailName);
        if (mxh != '') {
            return;
        }
        var date = getCurrDate();
        //得到开始年
        var sYear = date.getFullYear();

        for (var i = 0; i < 5; i++) {
            WfForm.addDetailRow(detailName);
        }
        for (var j = 0; j < 5; j++) {
            var addDate = (sYear + j);
            WfForm.changeFieldValue("field" + zdName + "_" + j, {
                value: addDate,
                specialobj: [{id: addDate.toString(), name: addDate.toString()}]
            });
        }
    }

    /**
     * 获取当前日期
     */
    function getCurrDate() {
        var myDate = '';
        jQuery.ajax({
            async: false,
            type: "POST",
            success: function (result, status, xhr) {
                myDate = new Date(xhr.getResponseHeader("Date"));
            }
        });
        return myDate;
    }

</script>












