package com.zy.vo;

import io.gd.generator.annotation.Field;
import lombok.Getter;
import lombok.Setter;

import java.io.Serializable;

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
    @Field(label = "用户名称")
    private String userName;
    @Field(label = "上级名称")
    private String parentName;
    @Field(label = "修改人名称")
    private String updateName;
    @Field(label = "是否有效")
    private Integer isEffect;
    @Field(label = "审核状态")
    private Integer auditStatus;
    @Field(label = "检测报告名称")
    private String reportTitle;
    @Field(label = "是否接车")
    private Integer isTransfers;
    @Field(label = "车次")
    private Integer carNumber;

    /* 扩展 */
    @Field(label = "票务照片")
    private String imageThumbnail;
    @Field(label = "创建时间")
    private String createdDateLabel;
    @Field(label = "更新时间")
    private String updateDateLabel;
    @Field(label = "计划到达时间")
    private String planTimeLabel;
}