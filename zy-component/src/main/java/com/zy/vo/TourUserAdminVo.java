package com.zy.vo;

import io.gd.generator.annotation.Field;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * Author: Xuwq
 * Date: 2017/6/29.
 */
@Getter
@Setter
public class TourUserAdminVo implements Serializable {
    /* 原生 */
    @Field(label = "id")
    private Long id;
    @Field(label = "旅游标题")
    private String tourTitle;
    @Field(label = "出游时间")
    private String tourTime;
    @Field(label = "用户id")
    private Long userId;
    @Field(label = "用户名称")
    private String userName;
    @Field(label = "身份证号")
    private String idCardNumber;
    @Field(label = "年龄")
    private Integer age;
    @Field(label = "性别")
    private String gender;
    @Field(label = "用户电话")
    private String userPhone;
    @Field(label = "上级名称")
    private String parentName;
    @Field(label = "上级电话")
    private String parentPhone;
    @Field(label = "旅游单号")
    private String sequenceId;
    @Field(label = "修改人名称")
    private String updateName;
    @Field(label = "是否有效")
    private Integer isEffect;
    @Field(label = "审核状态")
    private Integer auditStatus;
    @Field(label = "检测报告编号")
    private Long reportId;
    @Field(label = "是否接车")
    private Integer isTransfers;
    @Field(label = "车次")
    private String carNumber;
    @Field(label = "用户备注")
    private String userRemark;
    @Field(label = "审核备注")
    private String revieweRemark;
    @Field(label = "房型")
    private Integer houseType;
    @Field(label = "是否加床")
    private Integer isAddBed;

    @Field(label = "初访状态")
    private Integer firstVisitStatus;
    @Field(label = "二访状态")
    private Integer secondVisitStatus;
    @Field(label = "三访状态")
    private Integer thirdVisitStatus;
    @Field(label = "回访备注")
    private String visitRemark;
    @Field(label = "回访时间")
    private String visitTime;
    @Field(label = "visitUserId")
    private Long visitUserId;


    /* 扩展 */
    @Field(label = "票务照片")
    private String imageThumbnail;
    @Field(label = "创建时间")
    private String createdDateLabel;
    @Field(label = "更新时间")
    private String updateDateLabel;
    @Field(label = "计划到达时间")
    private String planTimeLabel;
//    @Field(label = "计划离开时间")
//    private String departureTimeLabel;
    @Field(label = "是否参游")
    private Integer isJoin;
    @Field(label = "消费金额")
    private BigDecimal amount;
    @Field(label = "所在地")
    private String province;
    @Field(label = "所在地")
    private String city;
    @Field(label = "所在地")
    private String district;
    @Field(label = "所在地")
    private Long areaId;
    @Field(label = "附加费")
    private Long surcharge;
    @Field(label = "退回保障金额")
    private Long refundAmount;
    @Field(label = "保障金额")
    private Long guaranteeAmount;
}
