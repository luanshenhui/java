import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import styled from 'styled-components';
import moment from 'moment';

import Table from '../../../components/Table';
import { getCourseListRequest } from '../../../modules/preference/scheduleModule';

moment.locale('ja', {
  weekdays: '日_月_火_水_木_金_土'.split('_'),
});
const fr = moment().locale('ja');

const MntTable = Table.extend`
  border-top: 1px solid #ccc;
  border-right: 1px solid #bbb;
  white-space: nowrap;
  text-align: center;
`;

const MntTd = styled.td`
  border-left: 1px solid #bbb;
  border-bottom: 1px solid #bbb;
  vertical-align: top;
  white-space: nowrap;
  text-align: center;
  width: 60px;
`;
const MntTh = styled.th`
  border-left: 1px solid #bbb;
  border-bottom: 1px solid #bbb;
  white-space: nowrap;
  text-align: center!important;
`;
class MntCapacityList extends React.Component {
  render() {
    const { data, lngCourseCount, lngRsvGrp, lngRsvGrpCountArray, sex, isNotFound } = this.props;
    let lngRowSpan = 0;
    let lngColSpan = 0;

    if (!data) {
      return null;
    }
    // 先頭行のROWSPAN値制御(性別指定時は１、さもなくば２)
    // 先頭行のCOLSPAN値制御(性別指定時は１、さもなくば２)
    if (sex === '0') {
      lngRowSpan = 2;
      lngColSpan = 2;
    } else {
      lngRowSpan = 1;
      lngColSpan = 1;
    }
    return (
      <div>
        {isNotFound && <p>コースを選択してください。</p>}
        {data.length !== 0 &&
          <div>
            <p>（登録人数／最大人数）</p>
            <MntTable striped hover>
              <thead>
                <tr key={1}>
                  <MntTh key={1} rowSpan={lngRowSpan}>日付</MntTh>
                  <MntTh key={2} rowSpan={lngRowSpan}>曜日</MntTh>
                  <MntTh key={3} rowSpan={lngRowSpan}>予約群</MntTh>
                  {data.map((rec, index) => {
                    if (index < lngCourseCount) {
                      return (<MntTh key={rec.cscd} colSpan={lngColSpan}><div style={{ width: '120px' }}>{rec.cssname}</div></MntTh>);
                    }
                    return null;
                  })}
                </tr>
                {sex === '0' &&
                  <tr key={2}>
                    {(() => {
                      const array = [];
                      for (let i = 0; i < lngCourseCount; i += 1) {
                        array.push(<MntTh key={2 * i}>男</MntTh>);
                        array.push(<MntTh key={2 * i + 1}>女</MntTh>);
                      }
                      return array;
                    })()}
                  </tr>
                }
              </thead>
              <tbody>
                {lngRsvGrp.map((rec, index) => {
                  const { date, blnExists, rsvgrpnameArray, holiday } = rec;
                  // (曜日の色)の設定
                  let color = '';
                  if (moment(date).day() === 6) {
                    color = '#006699';
                    if (holiday === 2) {
                      color = '#ff0000';
                    }
                  } else if (moment(date).day() === 0) {
                    color = '#ff0000';
                  } else if (holiday !== null) {
                    color = '#ff0000';
                  }
                  // 予約人数情報が存在する場合
                  if (blnExists) {
                    return rsvgrpnameArray.map((res, index1) => {
                      if (index1 === 0) {
                        return (
                          <tr key={res}>
                            <MntTd key={1} rowSpan={lngRsvGrpCountArray[index]} nowrap="true" valign="top">{moment(date).format('YYYY/MM/DD')}</MntTd>
                            <MntTd key={2} rowSpan={lngRsvGrpCountArray[index]} nowrap="true" valign="top" style={{ color }}>{fr.localeData().weekdays(moment(date))}</MntTd>
                            <MntTd key={3} nowrap="nowrap" style={{ textAlign: 'left' }}>{res}</MntTd>
                            {rec.data[index1].map((item) => {
                              const { CsCd } = item;
                              if (item.manageGenderResult === 0) {
                                return (<MntTd key={`${CsCd}A${res}d${date}`} colSpan={lngColSpan} style={{ backgroundColor: `#${item.strColor}` }}>{item.strRsvCount}</MntTd>);
                              } else if (item.manageGenderResult === 1) {
                                const arrayin = [];
                                if (sex !== '2') {
                                  arrayin.push(<MntTd key={`${CsCd}M${res}d${date}`} style={{ backgroundColor: `#${item.strColorM}` }}>{item.strRsvCountM}</MntTd>);
                                }
                                if (sex !== '1') {
                                  arrayin.push(<MntTd key={`${CsCd}F${res}d${date}`} style={{ backgroundColor: `#${item.strColorF}` }}>{item.strRsvCountF}</MntTd>);
                                }
                                return arrayin;
                              }
                              return (<MntTd key={`${CsCd}E${res}d${date}`} colSpan={lngColSpan} style={{ backgroundColor: '#ffffff' }}>&nbsp;</MntTd>);
                            })}
                          </tr>
                        );
                      }
                      return (
                        <tr key={res}>
                          <MntTd key={1} nowrap="nowrap" style={{ textAlign: 'left' }}>{res}</MntTd>
                          {rec.data[index1].map((item) => {
                            const { CsCd } = item;
                            if (item.manageGenderResult === 0) {
                              return (<MntTd key={`${CsCd}A${res}d${date}`} colSpan={lngColSpan} style={{ backgroundColor: `#${item.strColor}` }}>{item.strRsvCount}</MntTd>);
                            } else if (item.manageGenderResult === 1) {
                              const arrayin = [];
                              if (sex !== '2') {
                                arrayin.push(<MntTd key={`${CsCd}M${res}d${date}`} style={{ backgroundColor: `#${item.strColorM}` }}>{item.strRsvCountM}</MntTd>);
                              }
                              if (sex !== '1') {
                                arrayin.push(<MntTd key={`${CsCd}F${res}d${date}`} style={{ backgroundColor: `#${item.strColorF}` }}>{item.strRsvCountF}</MntTd>);
                              }
                              return arrayin;
                            }
                            return (<MntTd key={`${CsCd}E${res}d${date}`} colSpan={lngColSpan} style={{ backgroundColor: '#ffffff' }}>&nbsp;</MntTd>);
                          })}
                        </tr>
                      );
                    });
                  }
                  // 予約人数情報が存在しない場合
                  return (
                    <tr key={date}>
                      <MntTd key={`${date}1`}>{moment(date).format('YYYY/MM/DD')}</MntTd>
                      <MntTd key={`${date}2`} style={{ color }} nowrap="true">{fr.localeData().weekdays(moment(date))}</MntTd>
                      <MntTd key={`${date}3`} nowrap="true" colSpan={lngColSpan * lngCourseCount + 1} style={{ textAlign: 'left' }}>
                        {holiday === 1 && '休日'}
                        {holiday === 2 && '休日'}
                        {holiday === null && '予約枠なし'}
                      </MntTd>
                    </tr>
                  );
                })}
              </tbody>
            </MntTable>
          </div>
        }
      </div>
    );
  }
}

// propTypesの定義
MntCapacityList.propTypes = {
  lngRsvGrp: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  data: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  lngCourseCount: PropTypes.number.isRequired,
  lngRsvGrpCountArray: PropTypes.arrayOf(PropTypes.number).isRequired,
  sex: PropTypes.string.isRequired,
  isNotFound: PropTypes.bool.isRequired,
};
// defaultPropsの定義
MntCapacityList.defaultProps = {
};

const mapStateToProps = (state) => ({
  conditions: state.app.preference.schedule.mntCapacityList.conditions,
  courseListConditions: state.app.preference.schedule.courseList.conditions,
  data: state.app.preference.schedule.mntCapacityList.data,
  lngCourseCount: state.app.preference.schedule.mntCapacityList.lngCourseCount,
  lngRsvGrpCountArray: state.app.preference.schedule.mntCapacityList.lngRsvGrpCountArray,
  lngRsvGrp: state.app.preference.schedule.mntCapacityList.lngRsvGrp,
  startDate: state.app.preference.schedule.mntCapacityList.startDate,
  sex: state.app.preference.schedule.mntCapacityList.sex,
  isLoading: state.app.preference.schedule.mntCapacityList.isLoading,
  isNotFound: state.app.preference.schedule.mntCapacityList.isNotFound,
});
const mapDispatchToProps = (dispatch) => ({
  getCourseList: (startDate) => {
    dispatch(getCourseListRequest(startDate));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(MntCapacityList));
