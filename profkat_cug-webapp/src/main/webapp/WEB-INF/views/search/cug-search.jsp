<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="mcr" uri="http://www.mycore.org/jspdocportal/base.tld"%>
<%@ taglib prefix="search" tagdir="/WEB-INF/tags/search"%>

<c:set var="org.mycore.navigation.main.path" scope="request">main.search</c:set>
<c:set var="org.mycore.navigation.search.path" scope="request">search.search_${it.mask}</c:set>

<!doctype html>
<html>
  <head>
    <fmt:message var="pageTitle" key="Webpage.search.title.${it.mask}" />
    <title>${pageTitle} @ <fmt:message key="Nav.Application" /></title>
    <%@ include file="../fragments/html_head.jspf" %>
    <meta name="mcr:search.id" content="${it.result.id}" />
  </head>
  <body>
    <%@ include file="../fragments/header.jspf" %>
    <div id="content_area">
      <div class="container">
        <div class="row">
          <div id="search_nav" class="col-3">
            <c:set var="navId" value="search" />
            <c:if test="${fn:contains(it.result.mask, 'matrikel')}">
              <c:set var="navId" value="search-matrikel" />
            </c:if>
            <mcr:outputNavigation mode="side" id="${navId}" expanded="true"></mcr:outputNavigation>
          </div>
          <div id="search_content" class="col">
            <c:if test="${not empty it.result.mask}">
              <div class="row">
                <div class="col">
                  <c:set var="classCollapse" value="" />
                  <c:if test="${not it.showMask and it.result.numFound > 0 }">
                    <button
                      id="buttonCollapseSearchmask"
                      class="btn btn-secondary float-right"
                      type="button"
                      data-toggle="collapse"
                      data-target="#searchmask"
                      aria-expanded="false"
                      aria-controls="searchmask">
                      <fmt:message key="Webpage.Searchresult.redefine" />
                    </button>
                    <c:set var="classCollapse">collapse</c:set>
                  </c:if>
                  <div>
                    <mcr:includeWebcontent id="search_intro" file="search/${it.result.mask}_intro.html" />
                  </div>
                  <div class="searchmask ${classCollapse}" id="searchmask">
                    <c:out value="${it.xeditorHtml}" escapeXml="false" />
                  </div>
                  <script type="text/javascript">
                    $('#searchmask').on('show.bs.collapse', function (event) {
                      $('#buttonCollapseSearchmask').hide();
                      $('#buttonCollapseSearchmask2').hide();
                    });
                    $('#searchmask').on('shown.bs.collapse', function (event) {
                      event.target.scrollIntoView();
                    });
                  </script>
                </div>
              </div>
            </c:if>
            <c:if test="${it.showResults}">
              <c:if test="${not empty it.result.sortfields}">
                <search:result-sorter
                  result="${it.result}"
                  fields="${it.result.sortfields}"
                  mode="search"
                  mask="${it.result.mask}" />
              </c:if>
              <div class="row">
                <div class="col">
                  <search:result-browser result="${it.result}">
                    <c:set var="doctype" value="${fn:substringBefore(fn:substringAfter(mcrid, '_'),'_')}" />
                    <search:result-entry entry="${entry}" url="${url}" />
                    <div style="clear:both"></div>
                  </search:result-browser>
                </div>
              </div>
            </c:if>
            <script>
              $.urlParam = function(name){
                var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
                if (results==null){
                  return null;
                }
                else{
                  return results[1] || 0;
                }
              }
              $(function(){
                var field = $.urlParam('searchField');
                var value = $.urlParam('searchValue');
                if(field && value){
                  $('input#'+field.replace('.', '\\.')).val(decodeURIComponent(value));
                }
              });
            </script>
          </div>
        </div>
      </div>
    </div>
    <%@ include file="../fragments/footer.jspf" %>
  </body>
</html>
