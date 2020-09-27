import qs from 'qs';
import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { withRouter } from 'react-router-dom';
import { Field, reduxForm } from 'redux-form';
import Button from '../../../components/control/Button';
import Label from '../../../components/control/Label';
import CheckBox from '../../../components/control/CheckBox';
import MessageBanner from '../../../components/MessageBanner';
import DatePicker from '../../../components/control/datepicker/DatePicker';
import { FieldGroup, FieldSet, FieldItem } from '../../../components/Field';
import { rsvFraCopyRegister, rsvFraCopyBack } from '../../../modules/preference/scheduleModule';

const formName = 'RsvFraCopyHead';

const RsvFraCopyHead = (props) => {
  const { message, handleSubmit, rsvFraCopyRegisterClick, rsvFraCopyBackClick, history, location } = props;
  return (
    <div style={{ textAlign: 'left' }}>
      <form onSubmit={handleSubmit((values) => rsvFraCopyRegisterClick(values, location))} >
        <MessageBanner messages={message} />
        <FieldGroup itemWidth={200} >
          <div style={{ marginBottom: 13 }}>
            <span style={{ color: '#cc9999' }}>●</span>
            <span style={{ fontSize: 16 }}>コピー先情報を設定してください。</span>
          </div>
          <FieldSet>
            <FieldItem>コピー先範囲</FieldItem>
            <Field name="startcsldate" component={DatePicker} id="startdate" />
            <Label>～</Label>
            <Field name="endcsldate" component={DatePicker} id="enddate" />
          </FieldSet>
          <FieldSet>
            <FieldItem>対象曜日</FieldItem>
            <Field component={CheckBox} name="mon" checkedValue={1} label="月&nbsp;" />
            <Field component={CheckBox} name="tue" checkedValue={1} label="火&nbsp;" />
            <Field component={CheckBox} name="wed" checkedValue={1} label="水&nbsp;" />
            <Field component={CheckBox} name="thu" checkedValue={1} label="木&nbsp;" />
            <Field component={CheckBox} name="fri" checkedValue={1} label="金&nbsp;" />
            <Field component={CheckBox} name="sat" checkedValue={1} label="土&nbsp;" />
            <Field component={CheckBox} name="sun" checkedValue={1} label="日&nbsp;" />
          </FieldSet>
          <div style={{ marginLeft: 180 }}>
            <span style={{ color: '#999999' }}>（コピー先範囲が単一日の場合、この指定は無視されます。）</span>
          </div>
          <FieldSet>
            <FieldItem>処理モード</FieldItem>
            <Field component={CheckBox} name="upd" checkedValue={1} label="既に枠情報が存在する場合、上書きする" />
          </FieldSet>
          <FieldSet>
            <Button onClick={() => { rsvFraCopyBackClick(history); }} value="戻る" />
            <Button onClick={handleSubmit((values) => rsvFraCopyRegisterClick(values, location))} value="コピー" />
          </FieldSet>
        </FieldGroup>
      </form>
    </div>
  );
};

// propTypesの定義
RsvFraCopyHead.propTypes = {
  message: PropTypes.arrayOf(PropTypes.string).isRequired,
  handleSubmit: PropTypes.func.isRequired,
  rsvFraCopyRegisterClick: PropTypes.func.isRequired,
  rsvFraCopyBackClick: PropTypes.func.isRequired,
  history: PropTypes.shape().isRequired,
  location: PropTypes.shape(),
};

RsvFraCopyHead.defaultProps = {
  location: undefined,
};

const RsvFraCopyHeadForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RsvFraCopyHead);


const mapStateToProps = (state) => ({
  initialValues: state.app.preference.schedule.rsvFraCopy2.conditions,
  message: state.app.preference.schedule.rsvFraCopy2.message,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch) => ({
  rsvFraCopyRegisterClick: (inputItem, location) => {
    // (とりあえずはconfirm文を使用しているが本来はダイアログのコンポーネントによる出力でなければならない)
    // eslint-disable-next-line no-alert,no-restricted-globals
    if (!confirm('この内容で予約枠のコピーを行います。よろしいですか？')) {
      return;
    }
    // qsを利用してquerystringをオブジェクト型に変換
    const qsparams = qs.parse(location.search, { ignoreQueryPrefix: true });
    const { startcsldate, cscd, rsvgrpcd } = qsparams;
    dispatch(rsvFraCopyRegister({ ...inputItem, csldate: startcsldate, cscd, rsvgrpcd }));
  },
  rsvFraCopyBackClick: (history) => {
    const backFun = () => {
      history.push({
        pathname: '/contents/preference/schedule/rsvfracopy1',
        search: qs.stringify({ backFlag: '1' }),
      });
    };
    dispatch(rsvFraCopyBack({ backFun }));
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RsvFraCopyHeadForm));
