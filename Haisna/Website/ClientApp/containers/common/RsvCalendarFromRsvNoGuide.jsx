/**
 * @file カレンダー検索（予約番号）
 */
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { reduxForm, Field, getFormValues } from 'redux-form';
import moment from 'moment';

import DialogContent from '@material-ui/core/DialogContent';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import MessageBanner from '../../components/MessageBanner';
import GenderName from '../../components/common/GenderName';
import CheckBox from '../../components/control/CheckBox';
import DropDownYear from '../../components/control/dropdown/DropDownYear';
import DropDownMonth from '../../components/control/dropdown/DropDownMonth';

import RsvCslListChangedDateGuide from './RsvCslListChangedDateGuide';

import Calendar from '../../components/common/RsvCalendarGuide/Calendar';

import { RECENTCONSULT_RANGE_OF_MONTH, RsvCalendarGuideStatus } from '../../constants/common';

import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 450px;
  width: 600px;
`;

// レイアウト
const Section = styled.div`
  display: table;
`;
const Subtitle = styled.div`
  display: table-cell;
  width: 100px;
`;
const Cell = styled.div`
  display: table-cell;
`;
const PersonInfo = styled.div`
  display: table-cell;
  padding-left: 15px;
`;
const PersonLine = styled.div`
`;

const formName = 'rsvCalendarFromRsvNoGuide';

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const { cslmonth, cslyear } = state.app.reserve.consult.rsvCalendarFromRsvNoGuide.params;
  return {
    formValues,
    initialValues: { month: cslmonth, year: cslyear },
    guideState: state.app.reserve.consult.rsvCalendarFromRsvNoGuide,
  };
};

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

const RsvCalendarFromRsvNoGuide = (props) => {
  const { guideState, consultActions, formValues } = props;
  const { org = {} } = guideState.organization;

  const handleClose = () => {
    consultActions.closeRsvCalendarFromRsvNoGuide();
  };

  // すべての予約群コードがセットされている場合true
  const isSetAllRsvGrpCd = () => (
    !guideState.params.rsvgrpcd.some((value) => !value)
  );

  // アンカー要否(予約可否)の判定
  // false: アンカーなし true: アンカーあり
  const isSelectable = (dateSchedule) => {
    // 休診日、祝日の場合は選択できない
    if (dateSchedule.holiday) {
      return false;
    }
    // 過去の日付の場合は選択できない
    if (dateSchedule.status === RsvCalendarGuideStatus.Past) {
      return false;
    }
    // 契約なし、セット差異は選択できない
    if (dateSchedule.status === RsvCalendarGuideStatus.NoContract ||
        dateSchedule.status === RsvCalendarGuideStatus.DifferSet) {
      return false;
    }
    // 予約群未指定検索条件が存在する場合、強制予約はできない
    if (!isSetAllRsvGrpCd()) {
      return (dateSchedule.status === RsvCalendarGuideStatus.Normal || dateSchedule.status === RsvCalendarGuideStatus.Over);
    }
    return true;
  };

  // 年月変更時処理
  const handleChangeDate = (payload) => {
    const { cslyear, cslmonth } = guideState.params;
    consultActions.changeDateRsvCalendarFromRsvNoGuideRequest({ cslyear, cslmonth, ...payload });
  };

  // 日付選択時処理
  const handleSelected = (date) => {
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (confirm(`受診日:${moment(date).format('YYYY年MM月DD日')}で予約を行います。よろしいですか？`)) {
      const { recentConsults } = guideState;
      // ワーニング対象の最小日付
      const minCsldate = moment(date).subtract(RECENTCONSULT_RANGE_OF_MONTH, 'months');
      // ワーニング対象の最大日付
      const maxCsldate = moment(date).add(RECENTCONSULT_RANGE_OF_MONTH, 'months');

      const messages = [];
      for (let i = 0; i < recentConsults.length; i += 1) {
        // コースがドック、定期健診であり、かつ現在の受診日と異なる場合のみワーニングチェック対象とする
        if ((recentConsults[i].consult.cscd === '100' || recentConsults[i].consult.cscd === '110') &&
          !moment(date).isSame(moment(recentConsults[i].consult.csldate))) {
          // ワーニング対象の日付間に受診をしている個人がいた場合ワーニングメッセージを作成
          const csldates = recentConsults[i].data.filter((rec) => moment(rec.csldate).isBetween(minCsldate, maxCsldate, 'days')).map((rec) => moment(rec.csldate).format('YYYY年M月D日'));
          if (csldates.length > 0) {
            const { consult } = recentConsults[i];
            messages.push(`${consult.perid}:${consult.lastname}${'　'}${consult.firstname}${'　'}${csldates.join('、')}${'\n'}`);
          }
        }
      }

      // ワーニングメッセージが存在すればアラート表示
      if (messages.length > 0) {
        // eslint-disable-next-line no-alert,no-restricted-globals
        if (!confirm(`${messages.join('')}にこの受診者の受診情報がすでにに存在します。${'\n\n'}予約を行いますか？`)) {
          return false;
        }
      }
      const { ignoreFlg } = formValues;
      // 登録処理
      return consultActions.registerDateRsvCalendarFromRsvNoGuideRequest({ csldate: date, ignoreFlg });
    }
    return false;
  };

  return (
    <div>
      <Modal
        caption="カレンダー検索"
        open={guideState.visible}
        onClose={() => handleClose()}
      >
        <Content>
          <MessageBanner messages={guideState.messages} />
          <Section>
            <Subtitle>
              個人名
            </Subtitle>
            {guideState.consult.perid &&
              <Cell>
                {guideState.consult.perid}
              </Cell>
            }
            <PersonInfo>
              {guideState.consult.perid &&
                <PersonLine>
                  {guideState.consult.lastname}　{guideState.consult.firstname}　{(guideState.consult.lastkname || guideState.consult.firstkname) &&
                  `(${guideState.consult.lastkname}${'　'}${guideState.consult.firstkname})`}
                </PersonLine>
              }
              {guideState.consult.perid &&
                <PersonLine>
                  {guideState.consult.birth}　{guideState.consult.age && `${guideState.consult.age}歳`}　{guideState.consult.gender && <GenderName code={guideState.consult.gender} />}
                </PersonLine>
              }
            </PersonInfo>
          </Section>
          <Section>
            <Subtitle>
              団体名
            </Subtitle>
            <Cell>
              {org.orgcd1}-{org.orgcd2}　{org.orgname}　{org.orgkname && `(${org.orgkname})`}
            </Cell>
          </Section>
          <Section>
            <Subtitle>
              コース
            </Subtitle>
            <Cell>
              {guideState.contract.csname}
              {guideState.options.length > 0 &&
                `（${guideState.options.map((rec) => rec.optsname).join('、')}）`
              }
            </Cell>
          </Section>
          {!isSetAllRsvGrpCd() &&
            <Section>予約群の指定されていない検索条件があります。強制予約はできません。</Section>
          }
          {isSetAllRsvGrpCd() &&
            <Section><Field component={CheckBox} name="ignoreFlg" label="強制予約を行う" checkedValue={1} /></Section>
          }
          <Section>
            <Calendar year={guideState.params.cslyear} month={guideState.params.cslmonth} schedule={guideState.schedule} onSelected={handleSelected} isSelectable={isSelectable} />
            <Field name="year" component={DropDownYear} onChange={(e) => handleChangeDate({ cslyear: e.target.value })} />
            <Field name="month" component={DropDownMonth} onChange={(e) => handleChangeDate({ cslmonth: e.target.value })} />
          </Section>
        </Content>
      </Modal>
      <RsvCslListChangedDateGuide />
    </div>
  );
};

RsvCalendarFromRsvNoGuide.propTypes = {
  formValues: PropTypes.shape(),
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
};

RsvCalendarFromRsvNoGuide.defaultProps = {
  formValues: {},
};

const RsvCalendarFromRsvNoForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(RsvCalendarFromRsvNoGuide);

export default connect(mapStateToProps, mapDispatchToProps)(RsvCalendarFromRsvNoForm);
