import { createActions, handleActions } from 'redux-actions';

export const {
  initializeRsvGrp,
  getRsvGrpListRequest,
  getRsvGrpListSuccess,
  getRsvGrpListFailure,
  getRsvGrpListAllRequest,
  getRsvGrpListAllSuccess,
  getRsvGrpListAllFailure,
} = createActions(
  'INITIALIZE_RSV_GRP',
  'GET_RSV_GRP_LIST_REQUEST',
  'GET_RSV_GRP_LIST_SUCCESS',
  'GET_RSV_GRP_LIST_FAILURE',
  'GET_RSV_GRP_LIST_ALL_REQUEST',
  'GET_RSV_GRP_LIST_ALL_SUCCESS',
  'GET_RSV_GRP_LIST_ALL_FAILURE',
);

const initialState = {
  rsvgrp: {
    items: [],
  },
};

export default handleActions({
  [initializeRsvGrp]: (state) => {
    const { rsvgrp } = initialState;
    return { ...state, rsvgrp };
  },
  [getRsvGrpListSuccess]: (state, action) => {
    const { payload = [] } = action;
    const { rsvgrp } = state;
    const items = payload.map((rec) => ({ name: rec.rsvgrpname, value: rec.rsvgrpcd }));
    return { ...state, rsvgrp: { ...rsvgrp, items } };
  },
  [getRsvGrpListAllSuccess]: (state, action) => {
    const { payload = [] } = action;
    const { rsvgrp } = state;
    const items = payload.map((rec) => ({ name: rec.rsvgrpname, value: rec.rsvgrpcd }));
    return { ...state, rsvgrp: { ...rsvgrp, items } };
  },
}, initialState);
