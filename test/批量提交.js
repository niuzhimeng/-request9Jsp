let isRun = false;
const checkFlowId = [44, 45];
const {log} = console;

const myScript = () => {
    let dlcecodexy = WfForm.convertFieldNameToId("dlcecodexy");
    log('字段id： ', dlcecodexy);
    WfForm.bindFieldChangeEvent(dlcecodexy, function (obj, id, value) {
        log('value ', value)
        var fieldvalue = WfForm.getFieldValue(dlcecodexy);
        if (fieldvalue > 10) {
            WfForm.showMessage("校验值不得大于10", 1, 2); //错误信息，10s后消失
        }
    });
    isRun = true;
};

//作为执行钩子，采用这个钩子可以脱离代码块
ecodeSDK.overwritePropsFnQueueMapSet('WeaReqTop', {
    fn: (newProps) => {
        if (!ecodeSDK.checkLPath('/spa/workflow/static4form/index.html')) return;
        if (!WfForm) return;
        if (!ecCom.WeaTools.Base64) return;
        const baseInfo = WfForm.getBaseInfo();
        if (checkFlowId.indexOf(baseInfo.workflowid) === -1) return; //判断指定流程，不判断则是所有流程
        log('baseInfo.workflowid', baseInfo.workflowid);
        if (isRun) return;
        myScript();
    }
});
