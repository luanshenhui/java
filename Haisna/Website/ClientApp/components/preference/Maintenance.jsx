/**
 * @file Hains環境設定
 */
import React from 'react';
import { Route, Link } from 'react-router-dom';

import GroupList from '../../containers/preference/grp_r/GroupList';
import GroupEdit from '../../containers/preference/grp_r/GroupEdit';

import ItemClassList from './itemclass/ItemClassList';

import JudCmtStcList from './judcmtstc/JudCmtStcList';

import WorkStationList from '../../containers/preference/workstation/WorkStationList';
import WorkStationEdit from '../../containers/preference/workstation/WorkStationEdit';

import * as Constants from '../../constants/common';

const Maintenance = () => (
  <div>
    <div style={{ float: 'left', width: 200 }}>
      <div style={{ marginTop: 10, marginLeft: 10 }}>
        <p><Link to="/preference/maintenance/group">グループ</Link></p>
        <p><Link to="/preference/maintenance/itemclass">検査分類</Link></p>
        <p><Link to="/preference/maintenance/judcmtstc">判定コメント</Link></p>
        <p><Link to="/contents/preference/workstation?page=1&limit=20">管理端末</Link></p>
      </div>
    </div>
    <div style={{ marginLeft: 200 }}>
      <Route exact path="/preference/maintenance/group/" component={GroupList} />
      <Route exact path="/preference/maintenance/group/edit" component={GroupEdit} />
      <Route exact path="/preference/maintenance/group/edit/:grpcd" component={GroupEdit} />
      <Route path="/preference/maintenance/itemclass/" component={ItemClassList} />
      <Route path="/preference/maintenance/judcmtstc/" component={JudCmtStcList} />
      <Route exact path="/contents/preference/workstation" component={WorkStationList} />
      <Route exact path="/contents/preference/workstation/edit" component={WorkStationEdit} />
      <Route exact path="/contents/preference/workstation/edit/:ipaddress" component={WorkStationEdit} />
    </div>
  </div>
);

export default Maintenance;
