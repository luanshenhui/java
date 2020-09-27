import { createActions, handleActions } from 'redux-actions';

// actionの作成
export const {
  initializeContractCourceItems,
  getContractCourceItemsRequest,
  getContractCourceItemsSuccess,
  getContractCourceItemsFailure,
  initializeContractCslDivItems,
  getContractCslDivItemsRequest,
  getContractCslDivItemsSuccess,
  getContractCslDivItemsFailure,
  initializeContractOptions,
  getContractOptionsRequest,
  getContractOptionsSuccess,
  getContractOptionsFailure,
  initializeContractOptionItems,
} = createActions(
  'INITIALIZE_CONTRACT_COURCE_ITEMS',
  'GET_CONTRACT_COURCE_ITEMS_REQUEST',
  'GET_CONTRACT_COURCE_ITEMS_SUCCESS',
  'GET_CONTRACT_COURCE_ITEMS_FAILURE',
  'INITIALIZE_CONTRACT_CSL_DIV_ITEMS',
  'GET_CONTRACT_CSL_DIV_ITEMS_REQUEST',
  'GET_CONTRACT_CSL_DIV_ITEMS_SUCCESS',
  'GET_CONTRACT_CSL_DIV_ITEMS_FAILURE',
  'INITIALIZE_CONTRACT_OPTIONS',
  'GET_CONTRACT_OPTIONS_REQUEST',
  'GET_CONTRACT_OPTIONS_SUCCESS',
  'GET_CONTRACT_OPTIONS_FAILURE',
);

const initialState = {
  course: {
    items: [],
    data: [],
  },
  csldiv: {
    items: [],
    data: [],
  },
  options: null,
  optionItems: [],
};

export default handleActions({
  [initializeContractCourceItems]: (state) => {
    const { course } = initialState;
    return { ...state, course };
  },
  [getContractCourceItemsSuccess]: (state, action) => {
    const data = action.payload;
    const items = data.map((rec) => ({ name: rec.ctrcsname, value: rec.cscd }));
    const { course } = state;
    return { ...state, course: { ...course, items, data } };
  },
  [initializeContractCslDivItems]: (state) => {
    const { csldiv } = initialState;
    return { ...state, csldiv };
  },
  [getContractCslDivItemsSuccess]: (state, action) => {
    const data = action.payload;
    const items = data.map((rec) => ({ name: rec.csldivname, value: rec.csldivcd }));
    const { csldiv } = state;
    return { ...state, csldiv: { ...csldiv, items, data } };
  },
  [initializeContractOptions]: (state) => {
    const { options } = initialState;
    return { ...state, options };
  },
  [getContractOptionsSuccess]: (state, action) => {
    const options = action.payload;
    return { ...state, options };
  },
}, initialState);
