import { fromJS } from "immutable";
import NAMESPACE from "./namespace";

export const numberOfCases = state => {
  return state.getIn(["records", NAMESPACE, 'numberOfCases'], fromJS({
    dates: [],
    data: []
  }));
};

export const numberOfIncidents = state => {
  return state.getIn(["records", NAMESPACE, 'numberOfIncidents'], fromJS({
    dates: [],
    data: []
  }));
};

export const reportingDelay = state => {
  return state.getIn(["records", NAMESPACE, 'reportingDelay'], fromJS({
    data: []
  }));
};

export const serviceAccessDelay = state => {
  return state.getIn(["records", NAMESPACE, 'serviceAccessDelay'], fromJS({
    data: []
  }));
};
