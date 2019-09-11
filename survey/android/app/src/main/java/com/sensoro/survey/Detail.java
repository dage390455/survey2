package com.sensoro.survey;

import java.util.List;

public class Detail {
    /**
     * json : {"subList":[{"electricalFireId":1568031489618,"editenvironmentpic2":"","editenvironmentpic1":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_a00aed97-8bcb-4fbb-bab9-326f2929747d7292555787932371363.jpg","editenvironmentpic4":"","editenvironmentpic3":"","step4Remak":"","editenvironmentpic5":"","editPointArea":"","dangerous":"","headPerson":"早睡早起","editOutsinPic":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_dba42fd2-7700-40ef-ac43-47861cee106f4844681497816145118.jpg","isZhiHui":1,"page2editAddress":"日行一善","isOutSide":1,"editName":"该休息","current":"9797","bossPhone":"","isNeedLadder":1,"step3Remak":"","editAddress":"","isNeedCarton":1,"isNoiseReduction":0,"bossName":"","editLongitudeLatitude":"","editPosition":"","isEffectiveTransmission":1,"isNuisance":0,"recommendedTransformer":"","probeNumber":"0","editPurpose":"","editPointStructure":"","headPhone":"18911982866","currentSelect":"63A","isSingle":1,"editpic1":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_681e8487-1669-4996-b278-52342464831f6149127435123271730.jpg","isMolded":0,"editpic3":"","allOpenValue":1,"editpic2":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_56edb51e-a3cb-4de1-8cd5-820060ad2be35905385120322837650.jpg","page2editPurpose":"","editpic5":"","editpic4":"","step1Remak":"早睡早起"}],"createTime":"2019-09-09 20:18","remark":"","id":1568031480129,"projectName":"早睡早起武清站"}
     */

    private JsonBean json;

    public JsonBean getJson() {
        return json;
    }

    public void setJson(JsonBean json) {
        this.json = json;
    }

    public static class JsonBean {
        /**
         * subList : [{"electricalFireId":1568031489618,"editenvironmentpic2":"","editenvironmentpic1":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_a00aed97-8bcb-4fbb-bab9-326f2929747d7292555787932371363.jpg","editenvironmentpic4":"","editenvironmentpic3":"","step4Remak":"","editenvironmentpic5":"","editPointArea":"","dangerous":"","headPerson":"早睡早起","editOutsinPic":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_dba42fd2-7700-40ef-ac43-47861cee106f4844681497816145118.jpg","isZhiHui":1,"page2editAddress":"日行一善","isOutSide":1,"editName":"该休息","current":"9797","bossPhone":"","isNeedLadder":1,"step3Remak":"","editAddress":"","isNeedCarton":1,"isNoiseReduction":0,"bossName":"","editLongitudeLatitude":"","editPosition":"","isEffectiveTransmission":1,"isNuisance":0,"recommendedTransformer":"","probeNumber":"0","editPurpose":"","editPointStructure":"","headPhone":"18911982866","currentSelect":"63A","isSingle":1,"editpic1":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_681e8487-1669-4996-b278-52342464831f6149127435123271730.jpg","isMolded":0,"editpic3":"","allOpenValue":1,"editpic2":"/storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_56edb51e-a3cb-4de1-8cd5-820060ad2be35905385120322837650.jpg","page2editPurpose":"","editpic5":"","editpic4":"","step1Remak":"早睡早起"}]
         * createTime : 2019-09-09 20:18
         * remark :
         * id : 1568031480129
         * projectName : 早睡早起武清站
         */

        private String createTime;
        private String remark;
        private long id;
        private String projectName;
        private List<SubListBean> subList;

        public String getCreateTime() {
            return createTime;
        }

        public void setCreateTime(String createTime) {
            this.createTime = createTime;
        }

        public String getRemark() {
            return remark;
        }

        public void setRemark(String remark) {
            this.remark = remark;
        }

        public long getId() {
            return id;
        }

        public void setId(long id) {
            this.id = id;
        }

        public String getProjectName() {
            return projectName;
        }

        public void setProjectName(String projectName) {
            this.projectName = projectName;
        }

        public List<SubListBean> getSubList() {
            return subList;
        }

        public void setSubList(List<SubListBean> subList) {
            this.subList = subList;
        }

        public static class SubListBean {
            /**
             * electricalFireId : 1568031489618
             * editenvironmentpic2 :
             * editenvironmentpic1 : /storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_a00aed97-8bcb-4fbb-bab9-326f2929747d7292555787932371363.jpg
             * editenvironmentpic4 :
             * editenvironmentpic3 :
             * step4Remak :
             * editenvironmentpic5 :
             * editPointArea :
             * dangerous :
             * headPerson : 早睡早起
             * editOutsinPic : /storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_dba42fd2-7700-40ef-ac43-47861cee106f4844681497816145118.jpg
             * isZhiHui : 1
             * page2editAddress : 日行一善
             * isOutSide : 1
             * editName : 该休息
             * current : 9797
             * bossPhone :
             * isNeedLadder : 1
             * step3Remak :
             * editAddress :
             * isNeedCarton : 1
             * isNoiseReduction : 0
             * bossName :
             * editLongitudeLatitude :
             * editPosition :
             * isEffectiveTransmission : 1
             * isNuisance : 0
             * recommendedTransformer :
             * probeNumber : 0
             * editPurpose :
             * editPointStructure :
             * headPhone : 18911982866
             * currentSelect : 63A
             * isSingle : 1
             * editpic1 : /storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_681e8487-1669-4996-b278-52342464831f6149127435123271730.jpg
             * isMolded : 0
             * editpic3 :
             * allOpenValue : 1
             * editpic2 : /storage/emulated/0/Android/data/com.sensoro.survey/files/Pictures/scaled_56edb51e-a3cb-4de1-8cd5-820060ad2be35905385120322837650.jpg
             * page2editPurpose :
             * editpic5 :
             * editpic4 :
             * step1Remak : 早睡早起
             */
            long electricalFireId;

            String editName = ""; //勘察点信息
            String editPurpose = ""; //勘察点用途
            String editAddress = ""; //具体地址
            String editPosition = ""; //定位地址
            String editLongitudeLatitude = ""; //定位坐标
            String editPointStructure = ""; //勘察点结构
            String editPointArea = ""; //勘察点面积
            String headPerson = ""; //勘察点负责人
            String headPhone = ""; //勘察点电话
            String bossName = ""; //现场负责人姓名
            String bossPhone = ""; //现场负责人电话

            //第二页面

            //第一步
            String page2editAddress = ""; //电箱位置
            String page2editPurpose = ""; //电箱用途用途
            String step1Remak = ""; //电箱备注

            //第二步
            String editpic1 = ""; //第一张图片
            String editpic2 = ""; //第二张图片
            String editpic3 = ""; //第三张图片
            String editpic4 = ""; //第四张图片
            String editpic5 = ""; //第五张图片

            String editenvironmentpic1 = ""; //环境第一张图片
            String editenvironmentpic2 = ""; //第二张图片
            String editenvironmentpic3 = ""; //第三张图片
            String editenvironmentpic4 = ""; //第四张图片
            String editenvironmentpic5 = ""; //第五张图片

            //第三步
            int isNeedCarton = 1; //是否需要外箱
            int isOutSide = 1; //电箱位置
            int isNeedLadder = 1; //是否需要梯子
            String editOutsinPic = ""; //外箱安装位置图片
            String step3Remak = ""; //第三步备注

            //第四步
            int isEffectiveTransmission = 1; //报警音可否有效传播
            int isNuisance = 0; //是否扰民
            int isNoiseReduction = 0; //是否消音
            String step4Remak = ""; //第四步备注

            //第五步
            int allOpenValue = 1; //总开
            int isSingle = 1; //单项三箱
            int isMolded = 0; //是否微断

            String current = ""; //额定电流
            String dangerous = ""; //危险线路数
            String probeNumber = ""; //探头个数
            int isZhiHui = 1; //是否智慧空开
            String currentSelect = ""; //额定电流
            String recommendedTransformer = ""; //推荐互感器

            public long getElectricalFireId() {
                return electricalFireId;
            }

            public void setElectricalFireId(long electricalFireId) {
                this.electricalFireId = electricalFireId;
            }

            public String getEditenvironmentpic2() {
                return editenvironmentpic2;
            }

            public void setEditenvironmentpic2(String editenvironmentpic2) {
                this.editenvironmentpic2 = editenvironmentpic2;
            }

            public String getEditenvironmentpic1() {
                return editenvironmentpic1;
            }

            public void setEditenvironmentpic1(String editenvironmentpic1) {
                this.editenvironmentpic1 = editenvironmentpic1;
            }

            public String getEditenvironmentpic4() {
                return editenvironmentpic4;
            }

            public void setEditenvironmentpic4(String editenvironmentpic4) {
                this.editenvironmentpic4 = editenvironmentpic4;
            }

            public String getEditenvironmentpic3() {
                return editenvironmentpic3;
            }

            public void setEditenvironmentpic3(String editenvironmentpic3) {
                this.editenvironmentpic3 = editenvironmentpic3;
            }

            public String getStep4Remak() {
                return step4Remak;
            }

            public void setStep4Remak(String step4Remak) {
                this.step4Remak = step4Remak;
            }

            public String getEditenvironmentpic5() {
                return editenvironmentpic5;
            }

            public void setEditenvironmentpic5(String editenvironmentpic5) {
                this.editenvironmentpic5 = editenvironmentpic5;
            }

            public String getEditPointArea() {
                return editPointArea;
            }

            public void setEditPointArea(String editPointArea) {
                this.editPointArea = editPointArea;
            }

            public String getDangerous() {
                return dangerous;
            }

            public void setDangerous(String dangerous) {
                this.dangerous = dangerous;
            }

            public String getHeadPerson() {
                return headPerson;
            }

            public void setHeadPerson(String headPerson) {
                this.headPerson = headPerson;
            }

            public String getEditOutsinPic() {
                return editOutsinPic;
            }

            public void setEditOutsinPic(String editOutsinPic) {
                this.editOutsinPic = editOutsinPic;
            }

            public int getIsZhiHui() {
                return isZhiHui;
            }

            public void setIsZhiHui(int isZhiHui) {
                this.isZhiHui = isZhiHui;
            }

            public String getPage2editAddress() {
                return page2editAddress;
            }

            public void setPage2editAddress(String page2editAddress) {
                this.page2editAddress = page2editAddress;
            }

            public int getIsOutSide() {
                return isOutSide;
            }

            public void setIsOutSide(int isOutSide) {
                this.isOutSide = isOutSide;
            }

            public String getEditName() {
                return editName;
            }

            public void setEditName(String editName) {
                this.editName = editName;
            }

            public String getCurrent() {
                return current;
            }

            public void setCurrent(String current) {
                this.current = current;
            }

            public String getBossPhone() {
                return bossPhone;
            }

            public void setBossPhone(String bossPhone) {
                this.bossPhone = bossPhone;
            }

            public int getIsNeedLadder() {
                return isNeedLadder;
            }

            public void setIsNeedLadder(int isNeedLadder) {
                this.isNeedLadder = isNeedLadder;
            }

            public String getStep3Remak() {
                return step3Remak;
            }

            public void setStep3Remak(String step3Remak) {
                this.step3Remak = step3Remak;
            }

            public String getEditAddress() {
                return editAddress;
            }

            public void setEditAddress(String editAddress) {
                this.editAddress = editAddress;
            }

            public int getIsNeedCarton() {
                return isNeedCarton;
            }

            public void setIsNeedCarton(int isNeedCarton) {
                this.isNeedCarton = isNeedCarton;
            }

            public int getIsNoiseReduction() {
                return isNoiseReduction;
            }

            public void setIsNoiseReduction(int isNoiseReduction) {
                this.isNoiseReduction = isNoiseReduction;
            }

            public String getBossName() {
                return bossName;
            }

            public void setBossName(String bossName) {
                this.bossName = bossName;
            }

            public String getEditLongitudeLatitude() {
                return editLongitudeLatitude;
            }

            public void setEditLongitudeLatitude(String editLongitudeLatitude) {
                this.editLongitudeLatitude = editLongitudeLatitude;
            }

            public String getEditPosition() {
                return editPosition;
            }

            public void setEditPosition(String editPosition) {
                this.editPosition = editPosition;
            }

            public int getIsEffectiveTransmission() {
                return isEffectiveTransmission;
            }

            public void setIsEffectiveTransmission(int isEffectiveTransmission) {
                this.isEffectiveTransmission = isEffectiveTransmission;
            }

            public int getIsNuisance() {
                return isNuisance;
            }

            public void setIsNuisance(int isNuisance) {
                this.isNuisance = isNuisance;
            }

            public String getRecommendedTransformer() {
                return recommendedTransformer;
            }

            public void setRecommendedTransformer(String recommendedTransformer) {
                this.recommendedTransformer = recommendedTransformer;
            }

            public String getProbeNumber() {
                return probeNumber;
            }

            public void setProbeNumber(String probeNumber) {
                this.probeNumber = probeNumber;
            }

            public String getEditPurpose() {
                return editPurpose;
            }

            public void setEditPurpose(String editPurpose) {
                this.editPurpose = editPurpose;
            }

            public String getEditPointStructure() {
                return editPointStructure;
            }

            public void setEditPointStructure(String editPointStructure) {
                this.editPointStructure = editPointStructure;
            }

            public String getHeadPhone() {
                return headPhone;
            }

            public void setHeadPhone(String headPhone) {
                this.headPhone = headPhone;
            }

            public String getCurrentSelect() {
                return currentSelect;
            }

            public void setCurrentSelect(String currentSelect) {
                this.currentSelect = currentSelect;
            }

            public int getIsSingle() {
                return isSingle;
            }

            public void setIsSingle(int isSingle) {
                this.isSingle = isSingle;
            }

            public String getEditpic1() {
                return editpic1;
            }

            public void setEditpic1(String editpic1) {
                this.editpic1 = editpic1;
            }

            public int getIsMolded() {
                return isMolded;
            }

            public void setIsMolded(int isMolded) {
                this.isMolded = isMolded;
            }

            public String getEditpic3() {
                return editpic3;
            }

            public void setEditpic3(String editpic3) {
                this.editpic3 = editpic3;
            }

            public int getAllOpenValue() {
                return allOpenValue;
            }

            public void setAllOpenValue(int allOpenValue) {
                this.allOpenValue = allOpenValue;
            }

            public String getEditpic2() {
                return editpic2;
            }

            public void setEditpic2(String editpic2) {
                this.editpic2 = editpic2;
            }

            public String getPage2editPurpose() {
                return page2editPurpose;
            }

            public void setPage2editPurpose(String page2editPurpose) {
                this.page2editPurpose = page2editPurpose;
            }

            public String getEditpic5() {
                return editpic5;
            }

            public void setEditpic5(String editpic5) {
                this.editpic5 = editpic5;
            }

            public String getEditpic4() {
                return editpic4;
            }

            public void setEditpic4(String editpic4) {
                this.editpic4 = editpic4;
            }

            public String getStep1Remak() {
                return step1Remak;
            }

            public void setStep1Remak(String step1Remak) {
                this.step1Remak = step1Remak;
            }
        }
    }
}
