package com.zy.admin.controller.rpt;

import com.zy.common.model.query.Page;
import com.zy.common.model.query.PageBuilder;
import com.zy.common.model.result.Result;
import com.zy.common.model.result.ResultBuilder;
import com.zy.common.model.ui.Grid;
import com.zy.common.util.DateUtil;
import com.zy.common.util.ExcelUtils;
import com.zy.common.util.WebUtils;
import com.zy.component.TeamReportNewComponent;
import com.zy.entity.report.TeamReportNew;
import com.zy.entity.report.UserSpread;
import com.zy.entity.usr.UserUpgrade;
import com.zy.model.TeamReportVo;
import com.zy.model.query.TeamReportNewQueryModel;
import com.zy.model.query.UserSpreadQueryModel;
import com.zy.service.SystemCodeService;
import com.zy.service.TeamReportNewService;
import com.zy.util.GcUtils;
import com.zy.vo.TeamReportNewAdminVo;
import com.zy.vo.TeamReportNewExportVo;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.ParseException;
import org.apache.poi.util.StringUtil;
import org.apache.shiro.authz.annotation.RequiresPermissions;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Created by it001 on 2017/8/25.
 */
@Controller
@RequestMapping("/report/teamReportNew")
public class TeamReportNewController {

    private static final String SPLIT_PATTERN = "-";

    @Autowired
    private TeamReportNewService teamReportNewService;

    @Autowired
    private TeamReportNewComponent teamReportNewComponent;

    @Autowired
    private SystemCodeService systemCodeService;
    /**
     * get 查询 所有数据
     * @param model
     * @param queryDate
     * @return
     * @throws ParseException
     */
    @RequiresPermissions("teamReportNew:view")
    @RequestMapping(method = RequestMethod.GET)
    public String list(Model model, String queryDate) throws ParseException {
        TeamReportNewQueryModel teamReportNewQueryModel = new TeamReportNewQueryModel();
        if (StringUtils.isNotBlank(queryDate)){
            model.addAttribute("queryDate",queryDate);
        }else{
            model.addAttribute("queryDate",DateUtil.getYear(DateUtil.getBeforeMonthBegin(new Date(),-1,0))+SPLIT_PATTERN+DateUtil.getMothNum(DateUtil.getBeforeMonthBegin(new Date(),-1,0)));
        }
        model.addAttribute("queryDateLabels", getQueryTimeLabels());
        model.addAttribute("type", systemCodeService.findByType("LargeAreaType"));
        return "rpt/teamReportNewList";
    }


    /**
     *  post 查询 数据
     * @param model
     * @param teamReportNewQueryModel
     * @return
     * @throws ParseException
     */
    @RequiresPermissions("teamReportNew:view")
    @RequestMapping(method = RequestMethod.POST )
    @ResponseBody
    public Grid<TeamReportNewAdminVo> list(Model model, TeamReportNewQueryModel teamReportNewQueryModel,String queryDate) throws ParseException {
        if (StringUtils.isNotBlank(queryDate)){
            String [] ym = queryDate.split(SPLIT_PATTERN);
            teamReportNewQueryModel.setYearEQ(Integer.valueOf(ym[0]));
            teamReportNewQueryModel.setMonthEQ(Integer.valueOf(ym[1]));
        }
        Page<TeamReportNew> page = teamReportNewService.findPage(teamReportNewQueryModel);
        Page<TeamReportNewAdminVo> voPage = PageBuilder.copyAndConvert(page, v -> teamReportNewComponent.buildTeamReportNewVolumeListVo(v));
        return new Grid<>(voPage);
     }

    /**
     * 导出报表
     * @param teamReportNewQueryModel
     * @param response
     * @return
     * @throws IOException
     * @throws ParseException
     */
    @RequiresPermissions("teamReportNew:export")
    @RequestMapping("/export")
    public String export(TeamReportNewQueryModel teamReportNewQueryModel, HttpServletResponse response,String queryDate) throws IOException, ParseException{
        teamReportNewQueryModel.setPageSize(null);
        teamReportNewQueryModel.setPageNumber(null);
        if (StringUtils.isNotBlank(queryDate)){
            String [] ym = queryDate.split(SPLIT_PATTERN);
            teamReportNewQueryModel.setYearEQ(Integer.valueOf(ym[0]));
            teamReportNewQueryModel.setMonthEQ(Integer.valueOf(ym[1]));
        }
        List<TeamReportNew> salesVolume =  teamReportNewService.findExReport(teamReportNewQueryModel);
        String fileName = "销量报表"+teamReportNewQueryModel.getYearEQ()+"/"+teamReportNewQueryModel.getMonthEQ()+".xlsx";
        WebUtils.setFileDownloadHeader(response, fileName);

        List<TeamReportNewExportVo> teamReportNewAdminVos = salesVolume.stream().map(teamReportNewComponent::buildTeamReportNewExportVo).collect(Collectors.toList());
        OutputStream os = response.getOutputStream();
        ExcelUtils.exportExcel(teamReportNewAdminVos, TeamReportNewExportVo.class, os);

        return null;
    }


  @RequestMapping(value = "/reportEdit", method = RequestMethod.GET)
  public String reportEdit(Long teamReportNewId ,Model model){
      TeamReportNew teamReportNew = teamReportNewService.findOne(teamReportNewId);
      UserSpreadQueryModel userSpreadQueryModel = new UserSpreadQueryModel();
      userSpreadQueryModel.setUserIdEQ(teamReportNew.getUserId());
      userSpreadQueryModel.setYearEQ(teamReportNew.getYear());
      userSpreadQueryModel.setMonthEQ(teamReportNew.getMonth());
      List<UserSpread> userSpreadList = teamReportNewService.findUserSpread(userSpreadQueryModel);
      String [] name = new String [userSpreadList.size()];
      String [] v4 = new String [userSpreadList.size()];
      String [] v3 = new String [userSpreadList.size()];
      String [] v2 = new String [userSpreadList.size()];
      String [] v1 = new String [userSpreadList.size()];

      for(int i =0;i<userSpreadList.size();i++){
          UserSpread userSpread = userSpreadList.get(i);
          name[i]=userSpread.getProvinceName();
          v4[i]= userSpread.getV4()+"";
          v3[i]= userSpread.getV3()+"";
          v2[i]= userSpread.getV2()+"";
          v1[i]= userSpread.getV1()+"";
      }
      model.addAttribute("name",DateUtil.stringarryToString(name,false));
      model.addAttribute("v4",DateUtil.stringarryToString(v4,false));
      model.addAttribute("v3",DateUtil.stringarryToString(v3,false));
      model.addAttribute("v2",DateUtil.stringarryToString(v2,false));
      model.addAttribute("v1",DateUtil.stringarryToString(v1,false));
      return "rpt/teamReportNewEdit";
  }


    @RequestMapping(value = "ajaxTeamReportNew",method = RequestMethod.POST)
    @ResponseBody
    public Result<Object>  ajaxTeamReportNew(){
        TeamReportNewQueryModel teamReportNewQueryModel = new TeamReportNewQueryModel();
        teamReportNewQueryModel.setYearEQ(DateUtil.getYear(DateUtil.getBeforeMonthBegin(new Date(),-1,0)));
        teamReportNewQueryModel.setMonthEQ(DateUtil.getMothNum(DateUtil.getBeforeMonthBegin(new Date(),-1,0)));
        teamReportNewQueryModel.setIsBossEQ(1);
        teamReportNewQueryModel.setPageSize(null);
        teamReportNewQueryModel.setPageNumber(null);
        List<TeamReportNew> teamReportNewList =  teamReportNewService.findExReport(teamReportNewQueryModel);
        String []name = new String[teamReportNewList.size()];
        int [] extraNumber = new int[teamReportNewList.size()];
        int []newextraNumber = new int[teamReportNewList.size()];
        for (int i=0;i<teamReportNewList.size();i++){
            TeamReportNew teamReportNew = teamReportNewList.get(i);
            name[i]=teamReportNew.getUserName();
            extraNumber[i] = teamReportNew.getExtraNumber();
            newextraNumber[i] = teamReportNew.getNewextraNumber();
        }
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("namearry",name);
        map.put("extraNumberarry",extraNumber);
        map.put("newextraNumberarry",newextraNumber);
        return ResultBuilder.result(map);
    }

    private List<String> getQueryTimeLabels() {
        LocalDate begin = LocalDate.of(2016, 2, 1);
        LocalDate today = LocalDate.now();
        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM");
        List<String> timeLabels = new ArrayList<>();
        for (LocalDate itDate = begin; itDate.isEqual(today) || itDate.isBefore(today); itDate = itDate.plusMonths(1)) {
            timeLabels.add(dateTimeFormatter.format(itDate));
        }
        Collections.reverse(timeLabels);
        return timeLabels;
    }



}
