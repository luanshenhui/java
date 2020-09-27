import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import GridList from '@material-ui/core/GridList';
import GridListTile from '@material-ui/core/GridListTile';
import moment from 'moment';
import qs from 'qs';
import { getSelDateOrgRequest } from '../../modules/preference/organizationModule';
import { initDailyListParams, setDailyListParams } from '../../modules/reserve/consultModule';

// 今日の受診者取得（団体別）
class TodaysOrg extends React.Component {
  componentDidMount() {
    // ロード時処理を呼び出す
    const { initSelDateOrg } = this.props;
    // 今日の受診者取得（団体別）
    initSelDateOrg({ date: moment().format('YYYY/M/D') });
  }

  // 今日の受診者表示（団体別）クリック時の処理
  handleSelDateOrgClick(orgCd1, orgCd2) {
    const { history } = this.props;
    const strDate = moment().format('YYYY/M/D');

    history.push({
      pathname: '/reserve/frontdoor/dailylist',
      search: qs.stringify({ strDate, orgCd1, orgCd2 }),
    });
  }

  // 今日の受診者表示（団体別）
  render() {
    const { data } = this.props;

    // レコード数
    if (data.length === 0) return null;

    return (
      <div style={{ overflow: 'auto', height: '120px' }}>
        {data && data.length > 0 && (
          <GridList cellHeight="auto" style={{ width: '600px', marginLeft: '18px' }}>
            {data.map((rec) => (
              <GridListTile key={`${rec.orgcd1}-${rec.orgcd1}-${rec.orgname}-${rec.orgsu}`}>
                <span style={{ color: '#9fcfcf' }}>■</span>
                <a role="presentation" onClick={() => (this.handleSelDateOrgClick(rec.orgcd1, rec.orgcd2))} style={{ textDecoration: 'underline', color: '#006699', cursor: 'pointer' }}>
                  {rec.orgname}
                </a>
              </GridListTile>
            ))}
          </GridList>
        )}
      </div>
    );
  }
}

// propTypesの定義
TodaysOrg.propTypes = {
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  initSelDateOrg: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
};

const mapStateToProps = (state) => ({
  data: state.app.preference.organization.selDateOrg.data,
});

const mapDispatchToProps = (dispatch) => ({
  initSelDateOrg: (params) => {
    dispatch(getSelDateOrgRequest({ params }));
  },
  setNewParams: (params) => {
    dispatch(initDailyListParams());
    dispatch(setDailyListParams({ newParams: params }));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(TodaysOrg);

