<%@ include file="/WEB-INF/template/include.jsp"%> 
<%@ include file="/WEB-INF/view/module/mdrtb/mdrtbHeader.jsp"%>
<%@ taglib prefix="mdrtb" uri="/WEB-INF/view/module/mdrtb/taglibs/mdrtb.tld" %>

<openmrs:htmlInclude file="/scripts/jquery/jquery-1.3.2.min.js"/>

<openmrs:htmlInclude file="/moduleResources/mdrtb/mdrtb.css"/>


<!-- only show the headers if we are in edit mode (i.e,. we have an existing patient id) -->
<c:if test="${! empty patientId && patientId != -1}">
	<openmrs:portlet url="mdrtbPatientHeader" id="mdrtbPatientHeader" moduleId="mdrtb" patientId="${!empty patientId ? patientId : program.patient.id}"/>
	<openmrs:portlet url="mdrtbSubheader" id="mdrtbSubheader" moduleId="mdrtb" patientId="${!empty patientId ? patientId : program.patient.id}"/>
</c:if>

<!-- TODO: clean up above paths so they use dynamic reference -->
<!-- TODO: add privileges? -->

<!-- SPECIALIZED STYLES FOR THIS PAGE -->
<style type="text/css">
	th {vertical-align:top}
</style>

<!-- JQUERY FOR THIS PAGE -->
<script type="text/javascript"><!--

	var $j = jQuery.noConflict();	

	$j(document).ready(function(){

		// toggle the estimated checkbox
		$j('#birthdateEstimatedCheckbox').click(function () {
			if ($j(this).is(':checked')){
				$j('#birthdateEstimated').attr('value', "true");
			}
			else {
				$j('#birthdateEstimated').attr('value', "false");
			} 
		});

	});
-->
</script>
<!-- END JQUERY -->

<!-- START PAGE DIV -->
<div align="center">

<!--  EDIT/ADD PATIENT BOX -->

<b class="boxHeader" style="margin:0px"><spring:message code="mdrtb.patientDetails" text="Patient Details"/></b>
<div class="box" style="margin:0px;">

<!--  DISPLAY ANY ERROR MESSAGES -->
<c:if test="${fn:length(errors.allErrors) > 0}">
	<c:forEach var="error" items="${errors.allErrors}">
		<span class="error"><spring:message code="${error.code}"/></span><br/><br/>
	</c:forEach>
	<br/>
</c:if>

<form action="mdrtbEditPatient.form" method="POST">
<input type="hidden" name="successURL" value="${successURL}" />
<input type=hidden name="patientId" value="${patientId}"/>
<input type=hidden name="patientProgramId" value="${patientProgramId}"/>

<table style="padding:6px">

<tr>
<th style="headerCell"><spring:message code="Person.name"/></th>
<td>
<table cellspacing="0" cellpadding="0" border="0">
<openmrs:portlet url="nameLayout" id="namePortlet" size="columnHeaders" parameters="layoutShowTable=false|layoutShowExtended=false" /></td>
<spring:nestedPath path="patient.personName">
<openmrs:portlet url="nameLayout" id="namePortlet" size="inOneRow" parameters="layoutMode=edit|layoutShowTable=false|layoutShowExtended=false" />
</spring:nestedPath>
</table>
</td>
</tr>

<tr height="5"><td colspan="2">&nbsp;</td></tr>

<tr>
<th class="headerCell"><spring:message code="PatientIdentifier.title.endUser"/></th>
<td>
<table>
<tr>
<th><spring:message code="PatientIdentifier.identifierType"/></th>
<th><spring:message code="PatientIdentifier.identifier"/></th>
<c:if test="${showIdentifierLocationSelector}">
	<th><spring:message code="PatientIdentifier.location.identifier"/></th>
</c:if>
</tr>

<c:forEach var="type" items="${patientIdentifierTypesAutoAssigned}">
<input name="identifierId" type="hidden" value="${! empty patientIdentifierMap[type.id] ? patientIdentifierMap[type.id].id : ''}"/>
<input name="identifierType" type="hidden" value="${type.id}"/>
<input name="identifierValue" type="hidden" value="${! empty patientIdentifierMap[type.id] ? patientIdentifierMap[type.id].identifier : ''}"/>
<tr>
<td>${type.name}</td>
<td>
<c:choose>
	<c:when test="${! empty patientIdentifierMap[type.id]}">
		${patientIdentifierMap[type.id].identifier}
	</c:when>
	<c:otherwise>
		(<spring:message code="mdrtb.willBeAutoAssigned" text="Will be auto-assigned"/>)
	</c:otherwise>
</c:choose>
</td>
<c:if test="${showIdentifierLocationSelector}">
	<td><select name="identifierLocation">
	<option value=""/>
	<c:forEach var="location" items="${locations}">
		<option value="${location.id}" <c:if test="${location == patientIdentifierMap[type.id].location}">selected</c:if>>${location.displayString}</option>
	</c:forEach>
	</select>
</c:if>
</td>
</tr>
</c:forEach>	

<c:forEach var="type" items="${patientIdentifierTypes}">
<input name="identifierId" type="hidden" value="${! empty patientIdentifierMap[type.id] ? patientIdentifierMap[type.id].id : ''}"/>
<input name="identifierType" type="hidden" value="${type.id}"/>
<tr>
<td>${type.name}</td>
<td><input name="identifierValue" type="text" value="${! empty patientIdentifierMap[type.id] ? patientIdentifierMap[type.id].identifier : ''}"/></td>
<c:if test="${showIdentifierLocationSelector}">
	<td><select name="identifierLocation">
	<option value=""/>
	<c:forEach var="location" items="${locations}">
		<option value="${location.id}" <c:if test="${location == patientIdentifierMap[type.id].location}">selected</c:if>>${location.displayString}</option>
	</c:forEach>
	</select>
</c:if>
</td>
</tr>
</c:forEach>	
</table>
</td>
</tr>

<tr height="5"><td colspan="2">&nbsp;</td></tr>

<tr>
<th class="headerCell"><spring:message code="Person.address"/></th>
<td>
<spring:nestedPath path="patient.personAddress">
<openmrs:portlet url="addressLayout" id="addressPortlet" size="full" parameters="layoutMode=edit|layoutShowTable=true|layoutShowExtended=false" />
</spring:nestedPath>
</td>
</tr>

<tr height="5"><td colspan="2">&nbsp;</td></tr>

<tr>
<th class="headerCell"><spring:message code="patientDashboard.demographics"/></th>
<td>
<table cellspacing="3" cellpadding="3">
<tr>
<td><spring:message code="Person.gender"/></td>
<td>
<openmrs:forEachRecord name="gender">
<input type="radio" name="gender" id="${record.key}" value="${record.key}" <c:if test="${record.key == patient.gender}">checked</c:if> />
<label for="${record.key}"> <spring:message code="Person.gender.${record.value}"/> </label>
</openmrs:forEachRecord>
</td>
</tr>
<tr>
<td><spring:message code="Person.birthdate"/> </td>
<td>
<openmrs_tag:dateField formFieldName="birthdate" startValue="${patient.birthdate}"/>
<spring:message code="Person.birthdateEstimated"/>
<input type="hidden" id="birthdateEstimated" name="birthdateEstimated" value="${patient.birthdateEstimated}"/>
<input type="checkbox" id="birthdateEstimatedCheckbox" name="birthdateEstimatedCheckbox" value="true" <c:if test="${patient.birthdateEstimated == true}">checked</c:if> />
</td>
</tr>
</table>
</td>
</tr>

<tr height="5"><td colspan="2">&nbsp;</td></tr>

<openmrs:forEachDisplayAttributeType personType="patient" displayType="viewing" var="attrType">
	<tr>
		<th class="headerCell">
		<spring:message code="PersonAttributeType.${fn:replace(attrType.name, ' ', '')}" text="${attrType.name}"/></th>
		<td class="inputCell">
			<openmrs:fieldGen 
					type="${attrType.format}" 
					formFieldName="attributeMap[${attrType.name}].value" 
					val="${patient.attributeMap[attrType.name].hydratedObject}" 
					parameters="optionHeader=[blank]|showAnswers=${attrType.foreignKey}" />
		</td>
	</tr>
</openmrs:forEachDisplayAttributeType>

<tr height="5"><td colspan="2">&nbsp;</td></tr>

<tr><td colspan="2">
<button type="submit"><spring:message code="Patient.save" text="Save Patient"/></button>

<button type="reset" onclick="history.back()"><spring:message code="general.cancel" text="Cancel"/></button></td></tr>

</table>

</form>


</div>

</div> <!-- end of page div -->

<%@ include file="/WEB-INF/view/module/mdrtb/mdrtbFooter.jsp"%>