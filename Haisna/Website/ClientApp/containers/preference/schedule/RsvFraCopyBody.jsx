import qs from 'qs';
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import { withRouter } from 'react-router-dom';
import Table from '../../../components/Table';
import { openRsvFraGuide, getRsvFraListRequest, initializeRsvFraList } from '../../../modules/preference/scheduleModule';
import LabelCourseWebColor from '../../../components/control/label/LabelCourseWebColor';

class RsvFraCopyBody extends React.Component {
  constructor(props) {
    super(props);
    this.handleActionClick = this.handleActionClick.bind(this);
  }

  componentDidMount() {
    const { onLoad, location } = this.props;
    // qsを利用してquerystringをオブジェクト型に変換
    const qsparams = qs.parse(location.search, { ignoreQueryPrefix: true });
    onLoad({ ...qsparams });
  }

  // コンポーネントがアンマウントされる前に1回だけ呼ばれる処理
  componentWillUnmount() {
    // 一覧を初期化する
    const { initializeList } = this.props;
    initializeList();
  }

  handleActionClick({ data }) {
    const { onAction } = this.props;
    onAction(data);
  }

  render() {
    const { data } = this.props;
    return (
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
                <td>{moment(rec.csldate).format('YYYY/MM/DD')}</td>
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
    );
  }
}

// propTypesの定義
RsvFraCopyBody.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  onAction: PropTypes.func.isRequired,
  onLoad: PropTypes.func.isRequired,
  initializeList: PropTypes.func.isRequired,
  location: PropTypes.shape(),
};

RsvFraCopyBody.defaultProps = {
  location: undefined,
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
  initializeList: () => {
    dispatch(initializeRsvFraList());
  },
  onLoad: (conditions) => {
    // 画面を初期化
    const { startcsldate } = conditions;
    const wsdate = (startcsldate === '' ? moment(new Date()).format('YYYY/MM/DD') : startcsldate);
    dispatch(getRsvFraListRequest({ ...conditions, endcsldate: wsdate }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RsvFraCopyBody));
