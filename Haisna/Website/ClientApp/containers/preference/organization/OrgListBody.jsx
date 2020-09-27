import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { Link } from 'react-router-dom';

import Table from '../../../components/Table';

const OrgListBody = ({ data, target }) => (
  <Table striped hover>
    <thead>
      <tr>
        <th>団体コード</th>
        <th>団体名称</th>
        <th>団体カナ名称</th>
      </tr>
    </thead>
    <tbody>
      {data.map((rec) => (
        <tr key={`${rec.orgcd1}-${rec.orgcd2}`}>
          <td>{rec.orgcd1}-{rec.orgcd2}</td>
          <td>
            {target === 'org' && <Link to={`/contents/preference/organization/edit/${rec.orgcd1}/${rec.orgcd2}`}>{rec.orgname}</Link>}
            {target === 'contract' && <Link to={`/contents/preference/contract/organization/${rec.orgcd1}/${rec.orgcd2}/courses`}>{rec.orgname}</Link>}
          </td>
          <td>{rec.orgkname}</td>
        </tr>
      ))}
    </tbody>
  </Table>
);

// propTypesの定義
OrgListBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  target: PropTypes.string.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.organization.organizationList.data,
  target: state.app.preference.organization.target,
});

export default connect(mapStateToProps)(OrgListBody);
