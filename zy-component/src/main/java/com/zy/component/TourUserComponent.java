package com.zy.component;

import com.zy.common.util.BeanUtils;
import com.zy.entity.tour.Tour;
import com.zy.entity.tour.TourTime;
import com.zy.entity.tour.TourUser;
import com.zy.entity.usr.User;
import com.zy.entity.usr.UserInfo;
import com.zy.service.TourService;
import com.zy.service.TourTimeService;
import com.zy.service.UserInfoService;
import com.zy.service.UserService;
import com.zy.util.GcUtils;
import com.zy.vo.TourJoinUserExportVo;
import com.zy.vo.TourUserAdminVo;
import com.zy.vo.TourUserExportVo;
import com.zy.vo.TourUserListVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import static com.zy.util.GcUtils.getThumbnail;

/**
 * Author: Xuwq
 * Date: 2017/6/30.
 */
@Component
public class TourUserComponent {

    private static final String TIME_PATTERN = "yyyy-MM-dd HH:mm";

    private static final String S_TIME_PATTERN = "yyyy-MM-dd";

    @Autowired
    private UserService userService;

    @Autowired
    private UserInfoService userInfoService;

    @Autowired
    private TourService tourService;

    @Autowired
    private TourTimeService tourTimeService;


//    @Autowired
//    private TourService tourService;

    public TourUserAdminVo buildAdminVo(TourUser tourUser) {
        TourUserAdminVo tourUserAdminVo = new TourUserAdminVo();
        BeanUtils.copyProperties(tourUser, tourUserAdminVo);
        UserInfo userInfo = userInfoService.findByUserId(tourUser.getUserId());
        tourUserAdminVo.setUserName(userInfo.getRealname());
        UserInfo userIf = userInfoService.findByUserId(tourUser.getParentId());
        tourUserAdminVo.setParentName(userIf.getRealname());
        User user = userService.findOne(tourUser.getUserId());
        tourUserAdminVo.setUserPhone(user.getPhone());
        User use = userService.findOne(tourUser.getParentId());
        tourUserAdminVo.setParentPhone(use.getPhone());
        if (tourUser.getUpdateBy() != null){
            UserInfo userI = userInfoService.findByUserId(tourUser.getUpdateBy());
            tourUserAdminVo.setUpdateName(userI.getRealname());
        }
        if (tourUser.getTourId() != null){
            Tour tour = tourService.findTourOne(tourUser.getTourId());
            tourUserAdminVo.setTourTitle(tour.getTitle());
        }
        tourUserAdminVo.setCreatedDateLabel( GcUtils.formatDate(tourUser.getCreateDate(), TIME_PATTERN));
        tourUserAdminVo.setUpdateDateLabel( GcUtils.formatDate(tourUser.getUpdateDate(), TIME_PATTERN));
        tourUserAdminVo.setPlanTimeLabel( GcUtils.formatDate(tourUser.getPlanTime(), TIME_PATTERN));
        if (tourUser.getCarImages() != null) {
            tourUserAdminVo.setImageThumbnail(getThumbnail(tourUser.getCarImages(), 750, 450));
        }
        if (tourUser.getTourTimeId() != null){
            TourTime tourTime = tourTimeService.findOne(tourUser.getTourTimeId());
            tourUserAdminVo.setTourTime(GcUtils.formatDate(tourTime.getBegintime(), S_TIME_PATTERN) + "  至  " + GcUtils.formatDate(tourTime.getEndtime(), S_TIME_PATTERN));
        }
        return tourUserAdminVo;
    }

    public TourUserExportVo buildExportVo(TourUser tourUser) {
        return null;
    }

    public TourJoinUserExportVo buildJoinExportVo(TourUser tourUser) {
        TourJoinUserExportVo tourJoinUserExportVo = new TourJoinUserExportVo();
        BeanUtils.copyProperties(tourUser, tourJoinUserExportVo);
        UserInfo userInfo = userInfoService.findByUserId(tourUser.getUserId());
        tourJoinUserExportVo.setUserName(userInfo.getRealname());
        UserInfo userIf = userInfoService.findByUserId(tourUser.getParentId());
        tourJoinUserExportVo.setParentName(userIf.getRealname());
        User user = userService.findOne(tourUser.getUserId());
        tourJoinUserExportVo.setUserPhone(user.getPhone());
        User use = userService.findOne(tourUser.getParentId());
        tourJoinUserExportVo.setParentPhone(use.getPhone());
        if (tourUser.getAuditStatus() == 1){
            tourJoinUserExportVo.setAuditStatus("审核中");
        }else if (tourUser.getAuditStatus() == 2){
            tourJoinUserExportVo.setAuditStatus("待补充");
        }else if (tourUser.getAuditStatus() == 3){
            tourJoinUserExportVo.setAuditStatus("已生效");
        }else if (tourUser.getAuditStatus() == 4){
            tourJoinUserExportVo.setAuditStatus("已完成");
        }else if (tourUser.getAuditStatus() == 5){
            tourJoinUserExportVo.setAuditStatus("审核失败");
        }

        if (tourUser.getIsEffect() == 1){
            tourJoinUserExportVo.setIsEffect("是");
        }else if (tourUser.getIsEffect() == 0){
            tourJoinUserExportVo.setIsEffect("否");
        }

        if (tourUser.getIsAddBed() == 1){
            tourJoinUserExportVo.setIsAddBed("是");
        }else if (tourUser.getIsAddBed() == 0){
            tourJoinUserExportVo.setIsAddBed("否");
        }

        if (tourUser.getHouseType() == 1){
            tourJoinUserExportVo.setHouseType("标准间");
        }else if (tourUser.getHouseType() == 2){
            tourJoinUserExportVo.setHouseType("三人间");
        }

        if (tourUser.getUpdateBy() != null){
            UserInfo userI = userInfoService.findByUserId(tourUser.getUpdateBy());
            tourJoinUserExportVo.setUpdateName(userI.getRealname());
        }
        if (tourUser.getTourId() != null){
            Tour tour = tourService.findTourOne(tourUser.getTourId());
            tourJoinUserExportVo.setTourTitle(tour.getTitle());
        }
        if (tourUser.getIsTransfers() != null){
            if (tourUser.getIsTransfers() == 1){
                tourJoinUserExportVo.setIsTransfers("是");
            }else if (tourUser.getIsTransfers() == 0){
                tourJoinUserExportVo.setIsTransfers("否");
            }
        }

        if (tourUser.getIsJoin() != null){
            if (tourUser.getIsJoin() == 1){
                tourJoinUserExportVo.setIsJoin("是");
            }else if (tourUser.getIsJoin() == 0){
                tourJoinUserExportVo.setIsJoin("否");
            }
        }

        if (tourUser.getPlanTime() != null){
            tourJoinUserExportVo.setPlanTime(GcUtils.formatDate(tourUser.getPlanTime(), TIME_PATTERN));
        }
        tourJoinUserExportVo.setUpdateDateLabel( GcUtils.formatDate(tourUser.getUpdateDate(), TIME_PATTERN));
        if (tourUser.getCarImages() != null) {
            tourJoinUserExportVo.setImageThumbnail(getThumbnail(tourUser.getCarImages(), 750, 450));
        }
        if (tourUser.getTourTimeId() != null){
            TourTime tourTime = tourTimeService.findOne(tourUser.getTourTimeId());
            tourJoinUserExportVo.setTourTime(GcUtils.formatDate(tourTime.getBegintime(), S_TIME_PATTERN) + "  至  " + GcUtils.formatDate(tourTime.getEndtime(), S_TIME_PATTERN));
        }
        return tourJoinUserExportVo;
    }

    public TourUserListVo  buildListVo(TourUser tourUser) {
        TourUserListVo tourUserListVo = new TourUserListVo();
        BeanUtils.copyProperties(tourUser, tourUserListVo);
        Long tourTimeId = tourUser.getTourTimeId();
        Long parentId = tourUser.getParentId();
        if(tourTimeId != null){
            TourTime tourTime = tourTimeService.findOne(tourTimeId);
            tourUserListVo.setTourTime(GcUtils.formatDate(tourTime.getBegintime() , S_TIME_PATTERN));
        }
        if(parentId != null){
            User user = userService.findOne(parentId);
            tourUserListVo.setParentPhone(user.getPhone());
        }
        if (tourUser.getTourId() != null){
            Tour tour = tourService.findTourOne(tourUser.getTourId());
            tourUserListVo.setTourTitle(tour.getTitle());
        }
        return tourUserListVo ;
    }
}
