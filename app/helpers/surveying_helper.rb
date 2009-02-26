module SurveyingHelper

  # Formats the question number the way we want, or not at all if number is nil
  def question_number_helper(number)
    if number
      "#{number}<span style='padding-left:0.1em;'>)</span>" 
    else
      ""
    end
  end

  # splits the question text using the delimiter
  # parts before the delim. go before the input element, parts after the delim. go after the input element
  def question_text_prefix_helper(question_text = "")
    splits = question_text.split("|")
    unless splits[0].empty?
      splits[0] 
    else
      "&nbsp;"
    end      
  end
  
  # Parts of the question that go after the input element
  def question_text_postfix_helper(question_text = "")
    splits = question_text.split("|")
    if splits.size > 1
      splits[1] 
    else
      "&nbsp;"
    end
  end

  alias_method :answer_text_prefix_helper, :question_text_prefix_helper
  alias_method :answer_text_postfix_helper, :question_text_postfix_helper
  
  def section_id_helper(section)
    "section_#{section.id}"
  end

  def question_id_helper(question)
    "question_#{question.id}"
  end

  def answer_id_helper(answer)
    "answer_id_#{answer.id}"
  end

  def question_help_helper(question)
    question.help_text.blank? ? "" : %Q(<span class="question-help">#{question.help_text}</span>)
  end

  def fields_for_response(response, &block)
    fields_for("responses[#{response.question_id}][#{response.answer_id}]", response, :builder => SurveyFormBuilder, &block)
  end
  
  # Changes the response hash to accept response groups for repeater elements
  def fields_for_repeater_response(response, response_group, &block)
    fields_for("response_groups[#{response.question_id}][#{response_group}][#{response.answer_id}]", response, :builder => SurveyFormBuilder, &block)
  end
  
  def fields_for_radio(response, &block)
    fields_for("responses[#{response.question_id}]", response, :builder => SurveyFormBuilder, &block)
  end

  def section_submit_helper(section)
    submit_tag(section.title, :name => section_submit_name_helper(section))
  end

  def section_next_helper(section)
    submit_tag("Next section &gt;&gt;", :name => section_submit_name_helper(section))
  end

  def section_previous_helper(section)
    submit_tag("&lt;&lt; Previous section", :name => section_submit_name_helper(section))
  end

  def section_submit_name_helper(section, anchor_id = nil)
    "section[#{section.id}#{(anchor_id)? "_#{anchor_id}" : ""}]"
  end
  
  # Attempts to explain why this dependent question needs to be answered by referenced the dependent question and users response
  def dependency_explanation_helper(question,response_set)
    trigger_responses = []
    dependent_questions = Question.find_all_by_id(question.dependency.dependency_conditions.map(&:question_id)).uniq
    response_set.responses.find_all_by_question_id(dependent_questions.map(&:id)).uniq.each do |resp|
      trigger_responses << resp.to_s
    end
    "&nbsp;&nbsp;You answered &quot;#{trigger_responses.join("&quot; and &quot;")}&quot; to the question &quot;#{dependent_questions.map(&:text).join("&quot;,&quot;")}&quot;"
  end
  
end