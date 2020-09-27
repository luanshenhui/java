import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import styled from 'styled-components';
import moment from 'moment';
import BulletedLabel from '../../../components/control/BulletedLabel';
import Table from '../../../components/Table';
import { openRsvFraGuide } from '../../../modules/preference/scheduleModule';
import LabelCourseWebColor from '../../../components/control/label/LabelCourseWebColor';

const WrapperBullet = styled.div`
  .bullet { color: #cc9999 };
`;

class RsvFraSearchBody extends React.Component {
  constructor(props) {
    super(props);
    this.handleActionClick = this.handleActionClick.bind(this);
  }

  handleActionClick({ data }) {
    const { onAction } = this.props;
    onAction(data);
  }

  render() {
    const { data } = this.props;
    return (
      <div>
        <WrapperBullet>
          <BulletedLabel>受診日をクリックすると対象の予約枠設定内容修正画面が表示されます。</BulletedLabel>
        </WrapperBullet>
        <div>
          <Table striped hover>
            <thead>
              <tr>
                <th rowSpan="2">受診日</th>
                <th rowSpan="2">受診コース</th>
                <th rowSpan="2">予約群</th>
                <th colSpan="3" style={{ textAlign: 'center' }}>予約可能人数</th>
                <th colSpan="3" style={{ textAlign: 'center' }}>オーバ可能人数</th>
                <th colSpan="2" style={{ textAlign: 'center' }}>予約済み人数</th>
              </tr>
              <tr>
                <th style={{ textAlign: 'right' }}>共通</th>
                <th style={{ textAlign: 'right' }}>男</th>
                <th style={{ textAlign: 'right' }}>女</th>
                <th style={{ textAlign: 'right' }}>共通</th>
                <th style={{ textAlign: 'right' }}>男</th>
                <th style={{ textAlign: 'right' }}>女</th>
                <th style={{ textAlign: 'right' }}>男</th>
                <th style={{ textAlign: 'right' }}>女</th>
              </tr>
            </thead>
            <tbody>
              {data.map((rec, index) => (
                <tr key={`${rec.csldate}-${index.toString()}`}>
                  <td>
                    <a role="presentation" onClick={() => { this.handleActionClick({ data: rec }); }}>
                      <span style={{ color: '#006699' }} >{moment(rec.csldate).format('YYYY/MM/DD')}</span>
                    </a>
                  </td>
                  <td><LabelCourseWebColor webcolor={rec.webcolor}>■</LabelCourseWebColor>{rec.csname}</td>
                  <td>{rec.rsvgrpname}</td>
                  <td style={{ textAlign: 'right' }}>{rec.maxcnt}</td>
                  <td style={{ textAlign: 'right' }}>{rec.maxcnt_m}</td>
                  <td style={{ textAlign: 'right' }}>{rec.maxcnt_f}</td>
                  <td style={{ textAlign: 'right' }}>{rec.overcnt}</td>
                  <td style={{ textAlign: 'right' }}>{rec.overcnt_m}</td>
                  <td style={{ textAlign: 'right' }}>{rec.overcnt_f}</td>
                  <td style={{ textAlign: 'right' }}>{rec.rsvcnt_m}</td>
                  <td style={{ textAlign: 'right' }}>{rec.rsvcnt_f}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        </div>
      </div>
    );
  }
}

// propTypesの定義
RsvFraSearchBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onAction: PropTypes.func.isRequired,
};

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  data: state.app.preference.schedule.rsvfraList.data,
});

const mapDispatchToProps = (dispatch) => ({
  onAction: (data) => {
    // 予約枠登録・修正画面open
    const date = (data.csldate === '' ? moment(new Date()).format('YYYY/MM/DD') : moment(data.csldate).format('YYYY/MM/DD'));
    const conditions = { cscd: data.cscd, rsvgrpcd: data.rsvgrpcd };
    dispatch(openRsvFraGuide({ ...conditions, startcsldate: date, endcsldate: date }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RsvFraSearchBody);
