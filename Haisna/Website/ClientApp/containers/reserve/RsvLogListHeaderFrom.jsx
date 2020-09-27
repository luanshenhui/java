import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { Field, getFormValues, reduxForm, blur } from 'redux-form';
import { connect } from 'react-redux';

import { initializeRsvLogList, getConsultLogListRequest } from '../../modules/reserve/consultModule';
import { openUserGuide, closeUserGuide } from '../../modules/preference/hainsUserModule';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import GuideButton from '../../components/GuideButton';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';
import Chip from '../../components/Chip';
import UserGuide from '../common/UserGuide';

const formName = 'RsvLogListHeader';

const orderByItem = [
  { value: 0, name: '更新日' },
  { value: 1, name: '更新者' },
  { value: 2, name: '予約番号' },
];

const orderByMode = [
  { value: 0, name: '昇順' },
  { value: 1, name: '降順' },
];

const getCount = [
  { value: 50, name: '50行ずつ' },
  { value: 100, name: '100行ずつ' },
  { value: 200, name: '200行ずつ' },
  { value: 300, name: '300行ずつ' },
  { value: 9999, name: 'すべて' },
];

class RsvLogListHeader extends React.Component {
  constructor(props) {
    super(props);

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleSelectedUserGuide = this.handleSelectedUserGuide.bind(this);
    this.handleClear = this.handleClear.bind(this);
  }

  componentDidMount() {
    const { onLoad } = this.props;
    onLoad();
  }

  handleClear() {
    const { setValue } = this.props;
    setValue('userName', null);
    setValue('updUser', null);
  }

  // ユーザ一覧明細のセット
  handleSelectedUserGuide(items) {
    const { setValue, onCloseUserGuide } = this.props;
    setValue('userName', items.username);
    setValue('updUser', items.userid);
    onCloseUserGuide();
  }

  // 検索ボタンを押下
  handleSubmit(values) {
    const { onSearch } = this.props;
    onSearch({ ...values, startPos: 1 });
  }

  render() {
    const { handleSubmit, onOpenGdeUserGuide, formValues } = this.props;
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <FieldGroup itemWidth={100}>
            <FieldSet>
              <FieldItem>更新日</FieldItem>
              <Field name="startDate" component={DatePicker} id="startDate" />
              <Label>～</Label>
              <Field name="endDate" component={DatePicker} id="endDate" />
            </FieldSet>
            <FieldSet>
              <FieldItem>予約番号</FieldItem>
              <Field name="rsvNo" component="input" type="text" style={{ width: 100 }} />
            </FieldSet>
            <FieldSet>
              <FieldItem> 更新ユーザ </FieldItem>
              <GuideButton onClick={() => {
                onOpenGdeUserGuide();
              }}
              />
              <UserGuide onSelectRow={this.handleSelectedUserGuide} />
              <span><Chip onDelete={this.handleClear} /></span>
              <Field name="updUser" component="input" type="hidden" />
              <Label>{formValues && formValues.userName}</Label>
            </FieldSet>
            <FieldSet>
              <FieldItem> 表示 </FieldItem>
              <Field name="orderByItem" component={DropDown} items={orderByItem} id="orderByItem" selectedValue="0" />の
              <Field name="orderByMode" component={DropDown} items={orderByMode} id="orderByMode" selectedValue="0" />に
              <Field name="getCount" component={DropDown} items={getCount} id="getCount" selectedValue="0" />
              <Button style={{ marginLeft: '10px' }} onClick={() => this.handleSubmit(formValues)} value="表示" />
            </FieldSet>
          </FieldGroup>
        </div>
      </form>
    );
  }
}

const RsvLogListHeaderFrom = reduxForm({
  form: formName,
})(RsvLogListHeader);

// propTypesの定義
RsvLogListHeader.propTypes = {
  formValues: PropTypes.shape(),
  onLoad: PropTypes.func.isRequired,
  onSearch: PropTypes.func.isRequired,
  onOpenGdeUserGuide: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  setValue: PropTypes.func.isRequired,
  onCloseUserGuide: PropTypes.func.isRequired,
};

RsvLogListHeader.defaultProps = {
  formValues: undefined,
};

const mapStateToProps = (state) => {
  const formValues = getFormValues(formName)(state);
  return {
    formValues,
    initialValues: {
      startDate: moment().format('YYYY/MM/DD'),
      endDate: moment().format('YYYY/MM/DD'),
      orderByItem: 0,
      orderByMode: 0,
      getCount: 50,
    },
  };
};

const mapDispatchToProps = (dispatch) => ({
  onLoad: () => {
    // 画面を初期化
    dispatch(initializeRsvLogList());
  },

  onSearch: (params) => {
    dispatch(getConsultLogListRequest(params));
  },

  onOpenGdeUserGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openUserGuide());
  },

  onCloseUserGuide: () => {
    // 閉じるアクションを呼び出す
    dispatch(closeUserGuide());
  },

  setValue: (name, value) => {
    if (name === undefined) {
      return;
    }
    dispatch(blur(formName, name, value));
  },
});

export default connect(mapStateToProps, mapDispatchToProps)(RsvLogListHeaderFrom);
