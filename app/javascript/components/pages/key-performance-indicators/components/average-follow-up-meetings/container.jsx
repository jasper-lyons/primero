import React from "react";
import { OptionsBox } from "components/dashboard";
import { DateRangeSelect, SingleAggregateMetric } from "components/key-performance-indicators";

export default function AverageFollowUpMeetings() {
  let threeMonthsAgo = new Date();
  threeMonthsAgo.setMonth(threeMonthsAgo.getMonth() - 3)
  let dateRanges = [{
    value: '3-months',
    name: 'Last 3 Months',
    from: threeMonthsAgo,
    to: new Date()
  }]

  return (
    <OptionsBox
      title="Average Follow-Up Meetings"
      action={
        <DateRangeSelect
          ranges={dateRanges}
          selectedRange={dateRanges[0]}
          withCustomRange
        />
      }
    >
      <SingleAggregateMetric
        value="1.4"
        label="Average follow-up meetings"
      />
    </OptionsBox>
  );
}