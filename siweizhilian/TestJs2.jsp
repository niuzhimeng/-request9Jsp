// RF-10 非项目预算变更审批单 预算信息截取
<script type="text/javascript">
    // 预算信息1
    var ysfiled_one = 'field6606';
    // 触发字段1
    var chuFa_one = 'field6602,field6605,field6604';
    // 赋值字段1
    var fuZhi_one = 'field10415';

    // 预算信息2
    var ysfiled_two = 'field6611';
    // 触发字段2
    var chuFa_two = 'field6610,field6609,field6607';
    // 赋值字段2
    var fuZhi_two = 'field10513';

    $(function () {
        WfForm.bindDetailFieldChangeEvent(chuFa_one, function (id, rowIndex, value) {
            setTimeout(function () {
                myChange(ysfiled_one, fuZhi_one, rowIndex)
            }, 500);
        });

        WfForm.bindDetailFieldChangeEvent(chuFa_two, function (id, rowIndex, value) {
            setTimeout(function () {
                myChange(ysfiled_two, fuZhi_two, rowIndex)
            }, 500);
        });
    });

    function myChange(spanId, fuZhi, myIndex) {
        var query = $("#" + spanId + '_' + myIndex + 'span').children('font').text();
        var lastIndex = query.lastIndexOf(':');
        var substring = query.substring(lastIndex + 1);
        substring = substring.replace(/(^\s*)|(\s*$)/g, "");
        substring = substring.replace(/,/g, '');
        WfForm.changeFieldValue(fuZhi + '_' + myIndex, {value: substring});
    }
</script>


<script type="text/javascript">
    var ysfiled = 'field6606_0span';
    var mx1 = 'field6602';
    var bgje = 'field6612_0';

    $(function () {
        WfForm.bindDetailFieldChangeEvent(mx1, function (id, rowIndex, value) {
            console.log("WfForm.bindDetailFieldChangeEvent--", id, rowIndex, value);
            var ysVal = WfForm.getFieldValue(mx1);
            var query = $($("#" + ysfiled).children('span').get(1)).text();
            // var lastIndex = query.lastIndexOf(';');
            // var substring = query.substring(lastIndex + 1);
            alert('substring:  ' + query)
        });
    })
</script>

<script type="text/javascript">
    // 预算信息1
    var ysfiled_one = 'field6606';
    // 触发字段1
    var chuFa_one = 'field6604,field6605,field6602';
    // 赋值字段1
    var fuZhi_one = 'field9676';

    $(function () {
        WfForm.bindDetailFieldChangeEvent(chuFa_one, function (id, rowIndex, value) {
            setTimeout(function () {
                myChange(ysfiled_one, fuZhi_one, rowIndex)
            }, 500);
        });
    });

    function myChange(spanId, fuZhi, myIndex) {
        var query = $("#" + spanId + '_' + myIndex + 'span').children('font').text();
        var lastIndex = query.lastIndexOf(':');
        var substring = query.substring(lastIndex + 1);
        substring = substring.replace(/(^\s*)|(\s*$)/g, "");
        substring = substring.replace(/,/g, '');
        WfForm.changeFieldValue(fuZhi + '_' + myIndex, {value: substring});
    }
</script>

<script type="text/javascript">
    $(function () {
        // WfForm.afterFieldComp("field6344", React.createElement("a", {
        //     href: "http://www.baidu.com",
        //     children: "自定义链接"
        // }));

        WfForm.proxyFieldContentComp("6344", function (info, compFn) {
            console.log("字段id：", info.fieldid);
            console.log("明细行号：", info.rowIndex);
            console.log("字段只读必填属性：", info.viewAttr);
            console.log("字段值：", info.fieldValue);
            //返回自定义渲染的组件
            //return React.createElement("div", {}, ["想怎么玩就怎么玩"]);
            //返回原组件
            //return compFn();
            // 返回基于原组件的复写组件
            return React.createElement("div", {}, ["前置组件", compFn(), "后置组件"]);
        });
        //如果此接口调用在代码块、custompage等(非模块加载前调用)，需强制渲染字段一次
        WfForm.forceRenderField("field6344");
    });
</script>


<script type="text/javascript">
    const dhwb = WfForm.convertFieldNameToId("dhwb"); // 单行文本
    const rq2 = WfForm.convertFieldNameToId("rq2");
    const sf = WfForm.convertFieldNameToId("sf"); // 省份
    const xm = WfForm.convertFieldNameToId("xm", "detail_1");
    ecodeSDK.load({
        id: 'e22acae9381648b1afbd051b1bab7524',
        noCss: true, //是否禁止单独加载css，通常为了减少css数量，css默认前置加载
        cb: function () {
        }
    });
    $(function () {
        WfForm.setDetailAddUseCopy("detail_1", true);
        WfForm.afterFieldComp(dhwb, React.createElement("input", {
            type: "button",
            value: "代码块加的按钮",
            id: "buttonId",
            class: "ant-btn ant-btn-primary",
            onClick: () => {
                newButton();
            },
        }));

        // window.weaJs.alert('xm ' + xm);
        WfForm.changeFieldValue(sf, {
            value: "2"
        });

        WfForm.controlDateRange(rq2, -5, 10);
        WfForm.registerCheckEvent(WfForm.OPER_SUBMIT, (callback) => {
            WfForm.showConfirm("请问你是否需要技术协助？", function () {
                //点击确认调用的事件
                alert('点击确认调用的事件')
                //callback();
            }, function () {
                //点击取消调用的事件
                alert('点击取消调用的事件')
            }, {
                title: "信息确认", //弹确认框的title，仅PC端有效
                okText: "是", //自定义确认按钮名称
                cancelText: "否" //自定义取消按钮名称
            })
        });

        WfForm.registerCheckEvent(WfForm.OPER_ADDROW + "1", function (callback) {
            let mxh = WfForm.getDetailAllRowIndexStr('detail_1').split(',');
            let len = mxh.length;
            if (len >= 3) {
                WfForm.showMessage("明细行最多为3", 1, 2); //错误信息，10s后消失
                //window.weaJs.alert('明细行最多为3');
            } else {
                callback(); //允许继续添加行调用callback，不调用代表阻断添加 });
            }
        });


    });
    newButton = () => {
        const options = {
            url: '/api/hrm/getDataTest',
            method: 'get',
            params: {
                accesstime: 620,
            },
        };
        window.weaJs.callApi(options).then((myData) => {
            // console.log('res', myData);
            // let myJson = jQuery.parseJSON(myData);
            // console.log(myJson[0].lastname)
            console.log('myData', myData.data[0].lastname)
        });
    }

</script>

<script type="text/javascript">
    let rq2 = WfForm.convertFieldNameToId("rq2");
    ecodeSDK.load({
        id: 'e22acae9381648b1afbd051b1bab7524',
        noCss: true, //是否禁止单独加载css，通常为了减少css数量，css默认前置加载
        cb: function () {
        }
    });
    $(function () {
        WfForm.controlDateRange(rq2, -5, 10);
        WfForm.registerCheckEvent(WfForm.OPER_ADDROW + "1", function (callback) {
            let mxh = WfForm.getDetailAllRowIndexStr('detail_1').split(',');
            let len = mxh.length;
            if (len >= 3) {
                WfForm.showMessage("明细行最多为3", 1, 2); //错误信息，10s后消失
                //window.weaJs.alert('明细行最多为3');
            } else {
                callback(); //允许继续添加行调用callback，不调用代表阻断添加 });
            }
        });

        WfForm.registerCheckEvent(WfForm.OPER_SUBMIT, function (callback) {
            WfForm.showConfirm("确认提交？", function () {
                //点击确认调用的事件
                callback();
            }, function () {
                //点击取消调用的事件

            }, {
                title: "信息确认", //弹确认框的title，仅PC端有效
                okText: "是", //自定义确认按钮名称
                cancelText: "否" //自定义取消按钮名称
            })
        });
    })
</script>


<script type="text/javascript">
    $(function () {
        let att = [1, 1, 2, 2, 2, 3, 4, 5];
        let b = new Set(att)

        b.forEach(c => alert(c))
    })
</script>

<script type="text/javascript">
    jQuery(document).ready(function () {
        WfForm.setTextFieldEmptyShowContent("field6344", "单文本默认提示信息1");
        WfForm.setSignRemark("原有意见内容前追加请审批", false, false);
    })

</script>



