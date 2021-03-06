package com.shengpay.mcl.bp.api;

import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;
import javax.xml.bind.annotation.XmlSeeAlso;
import javax.xml.ws.RequestWrapper;
import javax.xml.ws.ResponseWrapper;

/**
 * This class was generated by Apache CXF 3.1.9
 * 2016-12-28T12:09:22.378+08:00
 * Generated source version: 3.1.9
 * 
 */
@WebService(targetNamespace = "http://api.bp.mcl.shengpay.com/", name = "BatchPayment")
@XmlSeeAlso({ObjectFactory.class, com.shengpay.mcl.btc.response.ObjectFactory.class})
public interface BatchPayment {

    @WebMethod(operationName = "Query")
    @RequestWrapper(localName = "Query", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.Query")
    @ResponseWrapper(localName = "QueryResponse", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.QueryResponse")
    @WebResult(name = "return", targetNamespace = "")
    public com.shengpay.mcl.btc.response.QueryResponse query(
        @WebParam(name = "arg0", targetNamespace = "")
        com.shengpay.mcl.bp.api.QueryRequest arg0
    );

    @WebMethod
    @RequestWrapper(localName = "apply", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.Apply")
    @ResponseWrapper(localName = "applyResponse", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.ApplyResponse")
    @WebResult(name = "return", targetNamespace = "")
    public com.shengpay.mcl.btc.response.BatchPaymentResponse apply(
        @WebParam(name = "arg0", targetNamespace = "")
        com.shengpay.mcl.bp.api.BatchPaymentRequest arg0
    );

    @WebMethod(operationName = "Generate")
    @RequestWrapper(localName = "Generate", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.Generate")
    @ResponseWrapper(localName = "GenerateResponse", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.GenerateResponse")
    @WebResult(name = "return", targetNamespace = "")
    public com.shengpay.mcl.btc.response.GenerateResultResponse generate(
        @WebParam(name = "arg0", targetNamespace = "")
        com.shengpay.mcl.bp.api.GenerateResultRequest arg0
    );

    @WebMethod
    @RequestWrapper(localName = "dateRangePaginationQuery", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.DateRangePaginationQuery")
    @ResponseWrapper(localName = "dateRangePaginationQueryResponse", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.DateRangePaginationQueryResponse")
    @WebResult(name = "return", targetNamespace = "")
    public com.shengpay.mcl.btc.response.DateRangePaginationQueryResponse dateRangePaginationQuery(
        @WebParam(name = "arg0", targetNamespace = "")
        com.shengpay.mcl.bp.api.DateRangePaginationQueryRequest arg0
    );

    @WebMethod(operationName = "DateRangeQuery")
    @RequestWrapper(localName = "DateRangeQuery", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.DateRangeQuery")
    @ResponseWrapper(localName = "DateRangeQueryResponse", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.DateRangeQueryResponse")
    @WebResult(name = "return", targetNamespace = "")
    public com.shengpay.mcl.btc.response.DateRangeQueryResponse dateRangeQuery(
        @WebParam(name = "arg0", targetNamespace = "")
        com.shengpay.mcl.bp.api.DateRangeQueryRequest arg0
    );

    @WebMethod
    @RequestWrapper(localName = "directApply", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.DirectApply")
    @ResponseWrapper(localName = "directApplyResponse", targetNamespace = "http://api.bp.mcl.shengpay.com/", className = "com.shengpay.mcl.bp.api.DirectApplyResponse")
    @WebResult(name = "return", targetNamespace = "")
    public com.shengpay.mcl.btc.response.DirectApplyResponse directApply(
        @WebParam(name = "arg0", targetNamespace = "")
        com.shengpay.mcl.bp.api.DirectApplyRequest arg0
    );
}
