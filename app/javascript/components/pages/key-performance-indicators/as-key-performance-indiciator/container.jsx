import React, { useEffect, useState } from "react";
import { connect } from "react-redux";
import { DateRangeSelect } from "components/key-performance-indicators/components/date-range-select";
// NOTE:  Importing 'compoenent/dashboard' casues tests to fail through
//        the 'pirates' module used in mocha I assume. No idea why this is.
import OptionsBox from "components/dashboard/options-box";
import { Tooltip } from "@material-ui/core";
import { useI18n } from "components/i18n";

import { forKPI as actionsForKPI } from "../action-creators";
import { forKPI as selectorsForKPI } from "../selectors";

const asKeyPerformanceIndicator = (identifier, defaultData) => {
  return Visualizer => {
    // TODO: need a better name for this
    const enhance = connect(
      state => ({ data: selectorsForKPI(identifier, state, defaultData) }),
      { fetchData: actionsForKPI(identifier) }
    );

    return enhance(({ data, fetchData, dateRanges, ...props }) => {
      const i18n = useI18n();

      const [currentDateRange, setCurrentDateRange] = useState(dateRanges[0]);

      useEffect(() => {
        fetchData(currentDateRange);
      }, [currentDateRange]);

      return (
        <OptionsBox
          title={
            <Tooltip placement="center" title={i18n.t(`key_performance_indicators.${identifier}.helptext`)}>
              <span>
                {i18n.t(`key_performance_indicators.${identifier}.title`)}
              </span>
            </Tooltip>
          }
          action={
            <DateRangeSelect
              ranges={dateRanges}
              selectedRange={currentDateRange}
              setSelectedRange={setCurrentDateRange}
              withCustomRange
            />
          }
        >
          <Visualizer identifier={identifier} data={data} {...props} />
        </OptionsBox>
      );
    });
  };
};

export default asKeyPerformanceIndicator;
