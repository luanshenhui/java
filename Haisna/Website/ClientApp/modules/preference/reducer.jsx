import { combineReducers } from 'redux';

import contract from './contractModule';
import course from './courseModule';
import free from './freeModule';
import group from './groupModule';
import hainsUser from './hainsUserModule';
import item from './itemModule';
import itemClass from './itemClassModule';
import judCmtStc from './judCmtStcModule';
import person from './personModule';
import rslCmt from './rslCmtModule';
import schedule from './scheduleModule';
import secondLineDiv from './secondLineDivModule';
import organization from './organizationModule';
import workstation from './workStationModule';
import zip from './zipModule';
import pubNote from './pubNoteModule';
import hainsLog from './hainsLogModule';

// reducerを結合
export default combineReducers({
  contract,
  course,
  free,
  group,
  hainsUser,
  item,
  itemClass,
  judCmtStc,
  person,
  rslCmt,
  schedule,
  secondLineDiv,
  organization,
  workstation,
  zip,
  pubNote,
  hainsLog,
});
