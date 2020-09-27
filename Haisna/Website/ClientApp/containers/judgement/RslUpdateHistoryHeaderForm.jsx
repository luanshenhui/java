import React from 'react';
import moment from 'moment';
import PropTypes from 'prop-types';
import { withRouter } from 'react-router-dom';
import { Field, blur, reduxForm } from 'redux-form';
import { connect } from 'react-redux';
import Chip from '../../components/Chip';
import GuideButton from '../../components/GuideButton';
import UserGuide from '../common/UserGuide';
import { openUserGuide } from '../../modules/preference/hainsUserModule';
import SectionBar from '../../components/SectionBar';
import { getUpdateLogListRequest, initializeLogList, setLogListParams } from '../../modules/judgement/interviewModule';
import DatePicker from '../../components/control/datepicker/DatePicker';
import DropDown from '../../components/control/dropdown/DropDown';
import { FieldGroup, FieldSet, FieldItem } from '../../components/Field';
import Label from '../../components/control/Label';
import Button from '../../components/control/Button';

const classInfoItems = [{ value: 0, name: 'すべて' }, { value: 1, name: '健診結果' }, { value: 2, name: '判定' }, { value: 3, name: 'コメント' }, { value: 4, name: '個人検査結果' }];
const orderByItemInfoItems = [{ value: 0, name: '更新日' }, { value: 1, name: '更新者' }, { value: 2, name: '分類、項目' }];
const orderByInfoItems = [{ value: 0, name: '昇順' }, { value: 1, name: '降順' }];
const pageMaxLineInfoItems = [{ value: 50, name: '50行ずつ' }, { value: 100, name: '100行ずつ' }, { value: 200, name: '200行ずつ' }, { value: 300, name: '300行ずつ' }, { value: 0, name: 'すべて' }];

const formName = 'rslUpdateHistoryHeader';

class RslUpdateHistoryHeader extends React.Component {
  constructor(props) {
    super(props);
    // このサンプルではsetStateで状態管理をしているが、実際はReduxのStoreで管理しなければならない
    this.state = {
      selectedItem: null,
    };
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  // コンポーネントがアンマウントされる前に1回だけ呼ばれる処理
  componentWillUnmount() {
    // 一覧を初期化する
    const { initializeList } = this.props;
    initializeList();
  }

  setUserInfo(selectedItem) {
    const { setNewParams } = this.props;

    if (selectedItem) {
      const { userid } = selectedItem;
      setNewParams({ searchupduser: userid });
    } else {
      setNewParams({ searchupduser: '' });
    }
  }

  // 表示
  handleSubmit(values) {
    const { onSubmit } = this.props;
    // onSubmitアクションの引数として渡す
    onSubmit(values);
  }

  render() {
    const { handleSubmit, onOpenUserGuide } = this.props;
    return (
      <form onSubmit={handleSubmit((values) => this.handleSubmit(values))}>
        <div>
          <SectionBar title="変更履歴" />
        </div>
        <FieldGroup itemWidth={60}>
          <FieldSet>
            <FieldItem>更新日</FieldItem>
            <Field name="startupddate" component={DatePicker} id="startupddate" />
            <Label>～</Label>
            <Field name="endupddate" component={DatePicker} id="endupddate" />
          </FieldSet>
          <FieldSet>
            <FieldItem>分類</FieldItem>
            <Field name="searchupdclass" component={DropDown} items={classInfoItems} id="searchupdclass" />
            <Label>更新ユーザ:</Label>
            <GuideButton onClick={() => onOpenUserGuide()} />
            {this.state.selectedItem && (
              <Chip
                label={this.state.selectedItem.username}
                onDelete={() => {
                  this.setUserInfo(null);
                  const selectedItem = null;
                  this.setState({ selectedItem });
                }}
              />
            )}
            <Label>表示:</Label>
            <Field name="orderbyitem" component={DropDown} items={orderByItemInfoItems} id="orderbyitem" />
            <Label>の</Label>
            <Field name="orderbymode" component={DropDown} items={orderByInfoItems} id="orderbymode" />
            <Label>に</Label>
            <Field name="limit" component={DropDown} items={pageMaxLineInfoItems} id="limit" />
            <Button type="submit" value="表示" />
          </FieldSet>
        </FieldGroup>
        <UserGuide
          onSelected={(selectedItem) => {
            this.setState({ selectedItem });
            this.setUserInfo(selectedItem);
          }}
        />
      </form>
    );
  }
}

// propTypesの定義
RslUpdateHistoryHeader.propTypes = {
  onOpenUserGuide: PropTypes.func.isRequired,
  setNewParams: PropTypes.func.isRequired,
  onSubmit: PropTypes.func.isRequired,
  handleSubmit: PropTypes.func.isRequired,
  initializeList: PropTypes.func.isRequired,
};

const RslUpdateHistoryHeaderForm = reduxForm({
  // form情報をstateで管理するためにアプリケーションで一意に名前を定義
  form: formName,
  // initialValuesの値が変更される度にformを再初期化(=再表示)するために必要なプロパティ(これが分からずにかなり地獄を見たorz)
  enableReinitialize: true,
})(RslUpdateHistoryHeader);

const mapStateToProps = (state) => ({
  initialValues: {
    startupddate: state.app.judgement.interview.rslUpdateHistoryList.conditions.startupddate,
    endupddate: state.app.judgement.interview.rslUpdateHistoryList.conditions.endupddate,
    searchupdclass: state.app.judgement.interview.rslUpdateHistoryList.conditions.searchupdclass,
    orderbyitem: state.app.judgement.interview.rslUpdateHistoryList.conditions.orderbyitem,
    orderbymode: state.app.judgement.interview.rslUpdateHistoryList.conditions.orderbymode,
    searchupduser: state.app.judgement.interview.rslUpdateHistoryList.conditions.searchupduser,
    limit: state.app.judgement.interview.rslUpdateHistoryList.conditions.limit,
  },
  conditions: state.app.judgement.interview.rslUpdateHistoryList.conditions,
});

// mapDispatchToPropsではreducerにactionを通知するためのdispatch処理をcomponentのpropsとしてどのように混ぜ込むかを定義する
const mapDispatchToProps = (dispatch, props) => ({
  onSubmit: (conditions) => {
    const { startupddate, endupddate } = conditions;
    const wsdate = (startupddate === '' ? moment(new Date()).format('YYYY/MM/DD') : startupddate);
    const wedate = (endupddate === '' ? moment(new Date()).format('YYYY/MM/DD') : endupddate);
    dispatch(blur(formName, 'startupddate', wsdate));
    dispatch(blur(formName, 'endupddate', wedate));

    const { rsvno } = props.match.params;
    const { limit } = conditions;
    dispatch(getUpdateLogListRequest({ page: 1, limit, ...conditions, rsvno, startupddate: wsdate, endupddate: wedate }));
  },
  initializeList: () => {
    dispatch(initializeLogList());
  },
  setNewParams: (params) => {
    dispatch(setLogListParams({ newParams: params }));
  },
  onOpenUserGuide: () => {
    // 開くアクションを呼び出す
    dispatch(openUserGuide());
  },
});

export default withRouter(connect(mapStateToProps, mapDispatchToProps)(RslUpdateHistoryHeaderForm));
