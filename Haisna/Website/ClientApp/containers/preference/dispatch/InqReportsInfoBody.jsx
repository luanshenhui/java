import React from 'react';
import moment from 'moment';
import { reduxForm, Field } from 'redux-form';
import styled from 'styled-components';
import { withRouter } from 'react-router-dom';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import LabelCourseWebColor from '../../../components/control/label/LabelCourseWebColor';
import CheckBox from '../../../components/control/CheckBox';
import Button from '../../../components/control/Button';

import Table from '../../../components/Table';
import { deleteConsultReptSendRequest, setStrMessage } from '../../../modules/report/reportSendDateModule';
import CommentListFlameGuide from '../../preference/comment/CommentListFlameGuide';
import { openCommentListFlameGuide } from '../../../modules/preference/pubNoteModule';

const Date = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

const TotalCount = styled.span`
  font-weight: bold;
  color: #ff6600;
`;

class InqReportsInfoBody extends React.Component {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(values) {
    const { reportitem, onSubmit, changeStrMessage } = this.props;
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('選択された成績書発送日をクリアします。よろしいですか？')) {
      return false;
    }
    const dateListDetail = [];
    const array = Object.keys(values);
    if (array.length > 0) {
      changeStrMessage('');
      for (let i = 0; i < array.length; i += 1) {
        const dateDetail = { Rsvno: reportitem[array[i]].rsvno, Seq: reportitem[array[i]].seq };
        dateListDetail.push(dateDetail);
      }
      onSubmit(dateListDetail);
    } else {
      changeStrMessage('クリアする成績書が一つも選択されていません');
    }
    return false;
  }

  // 描画処理
  render() {
    const { reportitem, conditions, totalcount, handleSubmit, onShowGuideNote, guideRsvno } = this.props;
    function PrefixInteger(num, length) {
      return (Array(length).join('0') + num).slice(-length);
    }
    return (
      <div>

        <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
          <div style={{ overflow: 'hidden' }}>
            <div style={{ float: 'left' }}>
              「<Date>{moment(conditions.strCslDate).format('YYYY年M月D日')}~{moment(conditions.endCslDate).format('YYYY年M月D日')}</Date>」の成績書作成情報一覧を表示しています。<br />
              検索結果は<TotalCount>{totalcount}</TotalCount>件（成績書枚数単位）です。{totalcount > 0 && <span style={{ color: '#999999' }}>（※受診者名称をクリックするとコメント情報が開きます）</span>}
            </div>
            <div style={{ float: 'left', marginLeft: '50px' }}>
              {totalcount > 0 &&
                <Button value="保存" type="submit" />
              }
            </div>
          </div>

          <Table striped hover>
            <thead>
              <tr>
                <th>受診日</th>
                <th>当日ＩＤ</th>
                <th>コース</th>
                <th>個人ＩＤ</th>
                <th>受診者名</th>
                <th>団体名</th>
                <th>後日GF</th>
                <th>後日CF</th>
                <th>英語</th>
                <th>発送確認日時</th>
                <th>担当者</th>
                <th>確認クリア</th>
                <th>注意事項</th>
                <th>予約番号</th>
              </tr>
            </thead>
            <tbody>
              {reportitem.map((item, index) => (
                <tr key={item.rsvno}>
                  <td nowrap="nowrap">{moment(item.csldate).format('YYYY/M/D')}</td>
                  <td nowrap="nowrap">{PrefixInteger(item.dayid, 4)}</td>
                  <td nowrap="nowrap"><LabelCourseWebColor webcolor={item.webcolor} />{item.csname}</td>
                  <td nowrap="nowrap">{item.perid}</td>
                  <td nowrap="nowrap">
                    <a
                      href="#"
                      alt="クリックするとコメント情報が開きます"
                      onClick={() => {
                        onShowGuideNote({
                          params: {
                            dispmode: '1',
                            cmtmode: '1,1,0,0',
                            perid: item.perid,
                            rsvno: item.rsvno,
                            orgcd1: null,
                            orgcd2: null,
                            ctrptcd: null,
                            startdate: null,
                            enddate: null,
                            act: null,
                          },
                        });
                      }}

                    >
                      <span style={{ fontSize: '9px' }}>{item.lastkname}{item.firstkname}</span><br />{item.lastname}{item.firstname}
                    </a>
                  </td>
                  <td nowrap="nowrap">{item.orgsname}</td>
                  <td nowrap="nowrap">{item.gfflg > 0 && 'GF'}</td>
                  <td nowrap="nowrap">{item.cfflg > 0 && 'GF'}</td>
                  <td nowrap="nowrap">{item.reportoureng === 1 && 'Eng'}</td>
                  <td nowrap="nowrap">{item.reportsenddate}</td>
                  <td nowrap="nowrap">{item.chargeusername}</td>
                  <td nowrap="nowrap">{item.reportsenddate !== null && <Field name={index} checkedValue="1" component={CheckBox} />}{item.reportsenddate}</td>
                  <td nowrap="nowrap">{item.pubnote}</td>
                  <td nowrap="nowrap">{item.rsvno}</td>
                </tr>
              ))}
            </tbody>
          </Table>
        </form>
        <CommentListFlameGuide rsvno={guideRsvno} dispmode="1" cmtmode="1,1,0,0" userid="HAINS$" />
      </div>
    );
  }
}

// mapStateToPropsではstateで保持している内容をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapStateToProps = (state) => ({
  reportitem: state.app.report.reportSendDate.ReportSendDateList.reportitem,
  totalcount: state.app.report.reportSendDate.ReportSendDateList.totalcount,
  conditions: state.app.report.reportSendDate.ReportSendDateList.conditions,
  guideRsvno: state.app.report.reportSendDate.ReportSendDateList.guideRsvno,
});

// propTypesの定義
InqReportsInfoBody.propTypes = {
  reportitem: PropTypes.arrayOf(PropTypes.shape()).isRequired,
  totalcount: PropTypes.number.isRequired,
  conditions: PropTypes.shape().isRequired,
  handleSubmit: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  onShowGuideNote: PropTypes.func.isRequired,
  guideRsvno: PropTypes.number.isRequired,
  changeStrMessage: PropTypes.func.isRequired,
};

// defaultPropsの定義
InqReportsInfoBody.defaultProps = {
};

const InqReportsInfoBodyForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: 'InqReportsInfoBodyForm',
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(InqReportsInfoBody);


// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  onSubmit: (conditions) => {
    dispatch(deleteConsultReptSendRequest(conditions));
  },
  // 情報コメント
  onShowGuideNote: (params) => {
    dispatch(openCommentListFlameGuide(params));
  },
  changeStrMessage: (strMessage) => {
    dispatch(setStrMessage(strMessage));
  },

});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(InqReportsInfoBodyForm));
