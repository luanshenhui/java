import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import moment from 'moment';
import qs from 'qs';
import { getSelDateCourseRequest } from '../../modules/preference/courseModule';
import { initDailyListParams, setDailyListParams } from '../../modules/reserve/consultModule';

// 今日の受診者取得（コース別）
class TodaysCourse extends React.Component {
  componentDidMount() {
    // ロード時処理を呼び出す
    const { initSelDateCourse } = this.props;
    // 今日の受診者取得（コース別）
    initSelDateCourse({ selDate: moment().format('YYYY/M/D') });
  }

  // 今日の受診者取得（コース別）クリック時の処理
  handleSelDateCourseClick(csCd) {
    const { history, setNewParams } = this.props;
    const strDate = moment().format('YYYY/M/D');
    setNewParams({ strDate, csCd });
    history.push({
      pathname: '/reserve/frontdoor/dailylist',
      search: qs.stringify({ strDate, csCd }),
    });
  }


  render() {
    const { data } = this.props;
    // レコード数
    if (data.length === 0) return null;

    return (
      <div style={{ marginLeft: '10px', overflow: 'auto', height: '120px' }}>
        {data && data.length > 0 && (
          data.map((rec) => (
            <div key={rec.cscd}>
              <span style={{ color: `#${rec.webcolor}` }}>■</span>
              <a role="presentation" onClick={() => (this.handleSelDateCourseClick(rec.cscd))} style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
                {rec.csname}
              </a>
            </div>
          ))
        )}
      </div>
    );
  }
}

// propTypesの定義
TodaysCourse.propTypes = {
  initSelDateCourse: PropTypes.func.isRequired,
  setNewParams: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
};

const mapStateToProps = (state) => ({
  data: state.app.preference.course.selDateCourse.data,
});

const mapDispatchToProps = (dispatch) => ({
  initSelDateCourse: (params) => {
    dispatch(getSelDateCourseRequest({ params }));
  },
  setNewParams: (params) => {
    dispatch(initDailyListParams());
    dispatch(setDailyListParams({ newParams: params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(TodaysCourse);
