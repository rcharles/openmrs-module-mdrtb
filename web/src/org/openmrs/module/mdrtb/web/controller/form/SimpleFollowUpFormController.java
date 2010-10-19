package org.openmrs.module.mdrtb.web.controller.form;

import java.lang.reflect.InvocationTargetException;

import javax.servlet.http.HttpServletRequest;

import org.openmrs.api.context.Context;
import org.openmrs.module.mdrtb.form.SimpleFollowUpForm;
import org.openmrs.module.mdrtb.form.SimpleIntakeForm;
import org.openmrs.module.mdrtb.program.MdrtbPatientProgram;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.support.SessionStatus;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

@Controller
@RequestMapping("/module/mdrtb/form/followup.form")
public class SimpleFollowUpFormController extends AbstractFormController {
	
	@ModelAttribute("followup")
	public SimpleFollowUpForm getIntakeForm(@RequestParam(required = true, value = "encounterId") Integer encounterId,
	                                      @RequestParam(required = true, value = "patientId") Integer patientId,
	                                      @RequestParam(required = false, value = "patientProgramId") Integer patientProgramId) throws SecurityException, IllegalArgumentException, NoSuchMethodException, IllegalAccessException, InvocationTargetException {

		// if no form is specified, create a new one
		if (encounterId == -1) {
			SimpleFollowUpForm form = new SimpleFollowUpForm(Context.getPatientService().getPatient(patientId));
		
			// prepopulate the form with information that has been specified
			if (patientProgramId != null) {
				MdrtbPatientProgram program = new MdrtbPatientProgram(Context.getProgramWorkflowService().getPatientProgram(patientProgramId));
				form.setLocation(program.getLocation());
			}
				
			return form;
		}
		else {
			return new SimpleFollowUpForm(Context.getEncounterService().getEncounter(encounterId));
		}
	}
	
	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView showFollowupForm() {
		ModelMap map = new ModelMap();
		return new ModelAndView("/module/mdrtb/form/followup", map);	
	}
	
	@RequestMapping(method = RequestMethod.POST)
	public ModelAndView processFollowupForm (@ModelAttribute("followup") SimpleFollowUpForm followup, BindingResult errors, 
	                                         @RequestParam(required = true, value = "patientId") Integer patientId,
	                                         @RequestParam(required = true, value = "patientProgramId") Integer patientProgramId,
	                                         @RequestParam(required = true, value = "returnUrl") String returnUrl,
	                                         SessionStatus status, HttpServletRequest request, ModelMap map) {

		// TODO: validate
		
		// save the actual update
		Context.getEncounterService().saveEncounter(followup.getEncounter());

		// clears the command object from the session
		status.setComplete();
		map.clear();

		// TODO: add a redirect handle here to handle proper redirect?
		return new ModelAndView(new RedirectView(returnUrl + "&patientId=" + patientId));
	}
}
