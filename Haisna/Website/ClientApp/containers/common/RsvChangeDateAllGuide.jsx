/**
 * @file 受診日一括変更ガイド
 */
import React from 'react';
import PropTypes from 'prop-types';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import styled from 'styled-components';
import { reduxForm, Field, getFormValues, FieldArray } from 'redux-form';
import moment from 'moment';

import DialogContent from '@material-ui/core/DialogContent';

// 共通コンポーネント
import Modal from '../../components/Modal/Modal';
import MessageBanner from '../../components/MessageBanner';
import CheckBox from '../../components/control/CheckBox';
import DropDownYear from '../../components/control/dropdown/DropDownYear';
import DropDownMonth from '../../components/control/dropdown/DropDownMonth';
import FieldGroup from '../../components/Field/FieldGroup';
import FieldSet from '../../components/Field/FieldSet';
import FieldItem from '../../components/Field/FieldItem';
import Table from '../../components/Table';
import Button from '../../components/control/Button';

import FieldRow from '../../components/common/RsvChangeDateAllGuide/FriendRow';
import RsvCalendarFromRsvNoGuide from './RsvCalendarFromRsvNoGuide';

import * as consultModules from '../../modules/reserve/consultModule';

// 表示領域の設定
const Content = styled(DialogContent)`
  height: 450px;
  width: 1000px;
`;

// 予約人数再帰検索モード(通常検索)
const MODE_NORMAL = 0;
// 予約人数再帰検索モード(同じ予約群グループで検索)
const MODE_SAME_RSVGRP = 1;

const formName = 'rsvChangeDateAllGuide';

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  const guideState = state.app.reserve.consult.rsvChangeDateAllGuide;
  const { csldate } = guideState.data.consult;
  return {
    formValues,
    guideState,
    initialValues: {
      ...guideState.data,
      year: csldate ? moment(csldate).format('YYYY') : null,
      month: csldate ? moment(csldate).format('M') : null,
      mode: true,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  consultActions: bindActionCreators(consultModules, dispatch),
});

const RsvChangeDateAllGuide = (props) => {
  const { guideState, consultActions, handleSubmit } = props;
  const { data } = guideState;

  // クローズ処理処理
  const handleClose = () => {
    consultActions.closeRsvChangeDateAllGuide();
  };

  // submit時処理
  const handleSubmitContent = (values) => {
    const targets = values.friends.filter((rec) => rec.isTarget && rec.isChange);
    const rsvno = targets.map((rec) => rec.friend.rsvno);
    const rsvgrpcd = targets.map((rec) => rec.friend.rsvgrpcd);

    // カレンダー検索ガイド（予約番号）を開く
    consultActions.openRsvCalendarFromRsvNoGuideRequest({
      mode: values.mode ? MODE_SAME_RSVGRP : MODE_NORMAL,
      cslyear: values.year,
      cslmonth: values.month,
      rsvno,
      rsvgrpcd,
      onSelected: () => handleClose(),
    });
  };

  return (
    <div>
      <Modal
        caption="受診日一括変更"
        open={guideState.visible}
        onClose={() => handleClose()}
      >
        <Content>
          <MessageBanner messages={guideState.messages} />
          <form onSubmit={handleSubmit((values) => handleSubmitContent(values))}>
            <FieldGroup>
              <FieldSet>
                <FieldItem>現受診日</FieldItem>
                {data.consult.csldate && moment(data.consult.csldate).format('YYYY年MM月DD日') }
              </FieldSet>
              <FieldSet>
                <FieldItem>検索年月</FieldItem>
                <Field component={DropDownYear} name="year" />年
                <Field component={DropDownMonth} name="month" />月
                <Field component={CheckBox} name="mode" label="より近い時間で検索" />
                <Button type="submit" value="検索" />
              </FieldSet>
            </FieldGroup>
            <FieldGroup>
              ●まとめて受診日変更を行う受診者をここで指定してください。
            </FieldGroup>
            <FieldGroup>
              {data.friends[0] &&
                <Table>
                  <thead>
                    <tr>
                      <th>操作／状態</th>
                      <th>個人ＩＤ</th>
                      <th>氏名</th>
                      <th>予約番号</th>
                      <th>受診団体</th>
                      <th>受診コース</th>
                      <th>予約群</th>
                    </tr>
                  </thead>
                  <FieldArray component={FieldRow} name="friends" count={1} mustChange />
                </Table>
              }
            </FieldGroup>
            <FieldGroup>
              {data.friends.length > 1 &&
                <Table>
                  <thead>
                    <tr>
                      <th colSpan="7">お連れ様の一覧</th>
                    </tr>
                  </thead>
                  <FieldArray component={FieldRow} name="friends" start={1} />
                </Table>
              }
            </FieldGroup>
          </form>
        </Content>
      </Modal>
      <RsvCalendarFromRsvNoGuide />
    </div>
  );
};

RsvChangeDateAllGuide.propTypes = {
  handleSubmit: PropTypes.func.isRequired,
  guideState: PropTypes.shape().isRequired,
  consultActions: PropTypes.shape().isRequired,
};

RsvChangeDateAllGuide.defaultProps = {
  formValues: {},
};

const RsvChangeDateAllGuideForm = reduxForm({
  form: formName,
  enableReinitialize: true,
})(RsvChangeDateAllGuide);

export default connect(mapStateToProps, mapDispatchToProps)(RsvChangeDateAllGuideForm);
