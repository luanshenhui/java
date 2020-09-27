import { combineReducers } from 'redux';
import consult from './consultModule';
import contract from './contractModule';
import schedule from './scheduleModule';
import webOrgRsv from './webOrgRsvModule';
import failsafe from './failSafeModule';

// reducerを結合
export default combineReducers({
  consult,
  contract,
  schedule,
  webOrgRsv,
  failsafe,
});
