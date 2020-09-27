import React from 'react';
import PropTypes from 'prop-types';
import { Link } from 'react-router-dom';

import moment from 'moment';

import Table from '../../components/Table';

import { genderName } from '../../constants/common';

const WebOrgRsvSearchBody = ({ data, openWebOrgRsvMainGuide, conditions }) => (
  <div>
    {data && data.length > 0 &&
      <Table striped hover style={{ whiteSpace: 'nowrap', width: '65%' }}>
        <thead>
          <tr>
            <th>受診希望日</th>
            <th>受診希望時間</th>
            <th>個人ＩＤ</th>
            <th>氏名</th>
            <th>性別</th>
            <th>生年月日</th>
            <th>契約団体名</th>
            <th>申込日</th>
            <th>申込取消日</th>
            <th>処理日</th>
            <th>状態</th>
            <th>処理</th>
          </tr>
        </thead>
        <tbody>
          {data.map((rec) => (
            <tr key={`${rec.name}-${rec.insdate}-${rec.upddate}`}>
              <td>{moment(rec.csldate).format('YYYY/M/D')}</td>
              <td>{rec.rsvgrpname}</td>
              <td>{rec.perid}</td>
              <td><a style={{ color: 'blue' }} role="presentation" onClick={() => openWebOrgRsvMainGuide({ ...conditions, data: rec })}>{rec.name}</a></td>
              <td>{genderName[rec.gender - 1]}</td>
              <td>{rec.birthyearshorteraname}{rec.birtherayear}.{moment(rec.birth).format('MM')}.{moment(rec.birth).format('DD')}</td>
              <td>{rec.orgname}</td>
              <td>{rec.insdate && moment(rec.insdate).format('YYYY/M/D')}</td>
              <td>{rec.candate && moment(rec.candate).format('YYYY/M/D')}</td>
              <td>{rec.upddate && moment(rec.upddate).format('YYYY/MM/DD hh:mm:ss A')}</td>
              <td>{rec.editdisp}</td>
              <td><Link to={`/contents/${rec.rsvno}`}>{rec.rsvno && '受診情報へ'}</Link></td>
            </tr>
          ))}
        </tbody>
      </Table >
    }
  </div>
);

// propTypesの定義
WebOrgRsvSearchBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  openWebOrgRsvMainGuide: PropTypes.func.isRequired,
  conditions: PropTypes.shape().isRequired,
};

export default WebOrgRsvSearchBody;
