import { fromJS } from "immutable";

import { mergeRecord } from "../../../../libs";

import { APPROVE_TRANSFER_SUCCESS } from "./actions";

const DEFAULT_STATE = fromJS({ data: [] });

export const reducers = namespace => (
  state = DEFAULT_STATE,
  { type, payload }
) => {
  switch (type) {
    case `${namespace}/${APPROVE_TRANSFER_SUCCESS}`: {
      const { data } = payload;
      const record = data.record;
      const index = state.get("data").findIndex(r => r.get("id") === record.id);
      if (index !== -1) {
        return state
          .updateIn(["data", index], u => mergeRecord(u, fromJS(record)))
          .set("errors", false);
      }

      return state
        .update("data", u => {
          return u.push(fromJS(record));
        })
        .set("errors", false);
    }
    default:
      return state;
  }
};
