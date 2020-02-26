<script type="text/javascript">
    $(function () {
        WfForm.proxyFieldContentComp("6310", function (info, compFn) {
            console.log("info", info)
            console.log("字段id：", info.fieldid);
            console.log("明细行号：", info.rowIndex);
            console.log("字段只读必填属性：", info.viewAttr);
            console.log("字段值：", info.fieldValue);
            //返回自定义渲染的组件
           // return React.createElement("div", {}, ["想怎么玩就怎么玩"]);
            //返回原组件
            //return compFn();
            //返回基于原组件的复写组件
            return React.createElement("div", {}, ["前置组件", compFn(), "后置组件"]);
        });
        //如果此接口调用在代码块、custompage等(非模块加载前调用)，需强制渲染字段一次
        WfForm.forceRenderField("field6310");
    })
</script>