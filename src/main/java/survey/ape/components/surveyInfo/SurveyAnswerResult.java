package survey.ape.components.surveyInfo;

import java.util.*;

public class SurveyAnswerResult {

    private Map<String, Map<String, Integer>> mcqToCount = new HashMap<>();
    private String startTime;
    private Map<String, String> mcq = new HashMap<>();
    private int participants;
    private Map<String, List<String>> textAnswers = new HashMap<>();
    private String endTime;
    private double participationRate;
    private Map<Integer, String> responseRates = new LinkedHashMap<>();

    public Map<String, String> getMcq() {
        return mcq;
    }

    public void setMcq(Map<String, String> mcq) {
        this.mcq = mcq;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public int getParticipants() {
        return participants;
    }

    public void setParticipants(int participants) {
        this.participants = participants;
    }

    public double getParticipationRate() {
        return participationRate;
    }

    public void setParticipationRate(double participationRate) {
        this.participationRate = participationRate;
    }

    public Map<String, Map<String, Integer>> getMcqToCount() {
        return mcqToCount;
    }

    public void setMcqToCount(Map<String, Map<String, Integer>> mcqToCount) {
        this.mcqToCount = mcqToCount;
    }

    public Map<String, List<String>> getTextAnswers() {
        return textAnswers;
    }

    public void setTextAnswers(Map<String, List<String>> textAnswers) {
        this.textAnswers = textAnswers;
    }

    public Map<Integer, String> getResponseRates() {
        return responseRates;
    }

    public void setResponseRates(Map<Integer, String> responseRates) {
        this.responseRates = responseRates;
    }

    public void prepareMCQ() {
        for (Map.Entry<String, Map<String, Integer>> each: mcqToCount.entrySet()) {
            String key = each.getKey();
            String jsonContent = "{\"chart\":{\"type\": \"pie\", \"data\":[";
            int size = each.getValue().size();
            int count = 0;

            for(Map.Entry<String, Integer> entry: each.getValue().entrySet()) {
                count++;
                jsonContent += "[\"" + entry.getKey() + "\", " + entry.getValue().toString() + "]";
                if (count != size) {
                    jsonContent += ", ";
                }
            }

            jsonContent += "]}}";

            mcq.put(key, jsonContent);
        }
    }
}
