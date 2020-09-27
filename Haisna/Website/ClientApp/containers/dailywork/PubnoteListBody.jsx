import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import Table from '../../components/Table';

const PubnoteListBody = ({ data }) => (
  <div>
    <div>
      <Table striped hover>
        <thead>
          <tr style={{ backgroundColor: '#eeeeee' }}>
            <th style={{ width: '925px' }}>団体コメント</th>
            <th>オペレータ名</th>
          </tr>
        </thead>
        {data && data.getpubnoteteamdata &&
          <tbody>
            {data.getpubnoteteamdata.map((rec, i) => (
              <tr key={i.toString()}>
                <td><span style={{ color: `"#${rec.dispcolor}"` }} >{rec.pubnote}</span></td>
                <td>{rec.username}</td>
              </tr>
          ))}
          </tbody>
          }
      </Table>
    </div>
    <div style={{ marginTop: '4px' }}>
      <Table striped hover>
        <thead>
          <tr style={{ backgroundColor: '#eeeeee' }}>
            <th style={{ width: '925px' }}>契約コメント</th>
            <th>オペレータ名</th>
          </tr>
        </thead>
        {data && data.getpubnotecontractdata &&
          <tbody>
            {data.getpubnotecontractdata.map((rec, i) => (
              <tr key={i.toString()}>
                <td><span style={{ color: `"#${rec.dispcolor}"` }} >{rec.pubnote}</span></td>
                <td>{rec.username}</td>
              </tr>
            ))}
          </tbody>
        }
      </Table>
    </div>
    <div style={{ marginTop: '4px' }}>
      <Table striped hover>
        <thead>
          <tr style={{ backgroundColor: '#eeeeee' }}>
            <th style={{ width: '925px' }}>個人コメント</th>
            <th>オペレータ名</th>
          </tr>
        </thead>
        {data && data.getpubnotedata &&
          <tbody>
            {data.getpubnotedata.map((rec, i) => (
              <tr key={i.toString()}>
                <td><span style={{ color: `"#${rec.dispcolor}"` }} >{rec.pubnote}</span></td>
                <td>{rec.username}</td>
              </tr>
            ))}
          </tbody>
        }
      </Table>
    </div>
  </div>
);

// propTypesの定義
PubnoteListBody.propTypes = {
  data: PropTypes.shape(),
};

PubnoteListBody.defaultProps = {
  data: {},
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.reserve.consult.receiptMainGuide.data,
});

export default connect(mapStateToProps)(PubnoteListBody);
